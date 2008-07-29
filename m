Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYG2C0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYG2C0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbYG2C0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:26:34 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:37679 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121AbYG2C0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:26:33 -0400
Date: Mon, 28 Jul 2008 22:26:18 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] omfs: fix sparse signedness warnings
Message-ID: <20080729022618.GA1880@hash.localnet>
References: <1217291828.23389.2.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217291828.23389.2.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 05:37:08PM -0700, Harvey Harrison wrote:
> Sorry, missed these in my other sparse warning fixes, feel free to fold it
> with the other one.

Looks good, thanks.

-- 
Bob Copeland %% www.bobcopeland.com

