Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYENHtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYENHtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYENHtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:49:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54633 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbYENHtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:49:10 -0400
Subject: Re: [PATCH] checkpatch: update the 80-char-line check to allow for
	long strings
From: Peter Zijlstra <peterz@infradead.org>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, mingo@elte.hu, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
In-Reply-To: <20080514005325.765178fc@ephemeral>
References: <20080514005325.765178fc@ephemeral>
Content-Type: text/plain
Date: Wed, 14 May 2008 09:49:06 +0200
Message-Id: <1210751346.10126.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-14 at 00:53 -0400, Andres Salomon wrote:
> 19:29 * dilinger sends his patch to lkml for a proper flaming
> 19:32  Quozl> dilinger: it's called "patch hardening"?  ;-}  the heat
>               of the flames makes the patch stronger.
> 
> I've wasted too much time massaging printk strings in order to satisfy
> checkpatch.pl.  Comments on this?

How about treating like its meant to be; as a guide instead of a hard
rule. That means you can ignore it with good taste.. :-)


