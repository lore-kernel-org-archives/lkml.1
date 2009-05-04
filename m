Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZEDPg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZEDPg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbZEDPgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:36:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41497 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbZEDPgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:36:18 -0400
Subject: Re: [PATCH] sched: rt: document the risk of small values in the
 bandwidth settings
From: Peter Zijlstra <peterz@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <49FF0AFF.8030303@oracle.com>
References: <1241449678.7620.4931.camel@twins> <49FF0AFF.8030303@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 04 May 2009 17:36:09 +0200
Message-Id: <1241451369.7620.4934.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 08:34 -0700, Randy Dunlap wrote:
> > +Fiddling with these settings can result in an unusable system, the knobs are
> > +root only and assume root knows what he's on about.
> 
> I know that my English is limited, but I don't know what this means:
>   "what he's on about."

Hehe, OK, how about we write it like:

Fiddling with these settings can result in an unstable system, the knobs are
root only and assumes root knows what he is doing.

Does that work better for you?
