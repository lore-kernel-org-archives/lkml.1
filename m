Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZGTOFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZGTOFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZGTOF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:05:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:44072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZGTOF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:05:28 -0400
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3]
 Resubmit VIA Chrome9 DRM via_chrome9 for upstream
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <4A647358.1040009@shipmail.org>
References: <4A647358.1040009@shipmail.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Jul 2009 16:06:13 +0200
Message-Id: <1248098773.15751.8908.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 15:38 +0200, Thomas Hellström wrote:
> Politics:
> It's true that sometimes some people don't like the code or what it 
> does. But when this is the underlying cause of NAK-ing a driver I think 
> it's very important that this is clearly stated, instead of inventing 
> various random reasons that can easily be argued against. How should the 
> driver writer otherwise get it right? Man-years might be spent fixing up 
> drivers that will never get upstream anyway.
> 
> I think it would help a lot of there was a documented set of driver 
> features that were required and sufficient for a DRM driver to go 
> upstream. It could look something like
> 
>     * Kernel coding style obeyed. Passing checkpatch.

      * fully functional GPL user-space driver.

How can you argue that something as tailor made as a DRM interface can
be used without it being a derived work?

FWIW my full vote goes against allowing such thing to happen, and I
think quite a lot of kernel people would agree with me.

I would hope enough of of them would so that we can stop this from
happening.

Negative karma points to you for trying to chip away at the spirit of
Linux.
