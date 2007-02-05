Return-Path: <linux-kernel-owner+w=401wt.eu-S1751553AbXBEQIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbXBEQIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbXBEQIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:08:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41221 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbXBEQIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:08:12 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070205155627.GA8354@elte.hu>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <20070205155627.GA8354@elte.hu>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 05 Feb 2007 17:08:08 +0100
Message-Id: <1170691688.3107.31.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 16:56 +0100, Ingo Molnar wrote:
> 
> btw., this whole select problem is not limited to Aunt Tillie: in a 
> couple of cases in the past few months when i saw some weird code in
> a 
> driver and tried to enable it i had to search around for many minutes 
> and enable random options to figure out its config dependencies until
> i 
> had the driver truly enabled. (if there's some easy solution to this 
> then i'm all ears - but i exclude the easiest solution of adding me
> to 
> the 'aunt' category ;-) I think that by blaming Aunt Tillie you might
> be 
> missing the real problem. 

the real problem is that we plain have way too many config options ;)
While it's nice to make some things conditional, I have the feeling that
things have gone too far in the kernel today....


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

