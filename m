Return-Path: <linux-kernel-owner+w=401wt.eu-S966375AbZLHVmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966375AbZLHVmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZLHVmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:42:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43307 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315AbZLHVmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:42:42 -0500
Date: Tue, 8 Dec 2009 22:42:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: HTC Dream: mmc compilation fixes
Message-ID: <20091208214241.GB4164@elf.ucw.cz>
References: <20091206195953.GA26863@elf.ucw.cz>
 <1260305123.11826.25.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260305123.11826.25.camel@c-dwalke-linux.qualcomm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-12-08 12:45:22, Daniel Walker wrote:
> On Sun, 2009-12-06 at 20:59 +0100, Pavel Machek wrote:
> > +
> > +struct embedded_sdio_data {
> > +        struct sdio_cis cis;
> > +        struct sdio_cccr cccr;
> > +        struct sdio_embedded_func *funcs;
> > +        int num_funcs;
> > +};
> 
> 
> There's some indentation problems in this block, I'll fix it prior to
> merging it..

Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
