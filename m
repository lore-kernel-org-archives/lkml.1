Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbXGaNvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbXGaNvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbXGaNvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:51:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52676 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbXGaNvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:51:05 -0400
Date: Tue, 31 Jul 2007 19:33:23 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Felipe Balbi <felipebalbi@users.sourceforge.net>
cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: Crypto API Weirdnesses
In-Reply-To: <31e679430707310643h670ffb1bg852f0e14eafa11a9@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0707311930340.26032@enigma.security.iitk.ac.in>
References: <31e679430707301336v37bc7433jed09451ab60ad89a@mail.gmail.com> 
 <alpine.LFD.0.999.0707311837470.26032@enigma.security.iitk.ac.in> 
 <961aa3350707310626l24d1d910u75ed703d8d422082@mail.gmail.com> 
 <31e679430707310632u52f43fefg8313143953ccb9b3@mail.gmail.com> 
 <alpine.LFD.0.999.0707311916150.26032@enigma.security.iitk.ac.in>
 <31e679430707310643h670ffb1bg852f0e14eafa11a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, Felipe Balbi wrote:

> On 7/31/07, Satyam Sharma <satyam@infradead.org> wrote:
> > [...]
> > Ugh, you should at least be checking if you've built the kernel with the
> > same config options :-) Of course, if you did a simple "make oldconfig"
> > but still lost some config options, then that's definitely a regression...
> > (was that the case here, btw?)
> 
> yeah... I was make oldconfig'ing :-p

Hmm, can you send the 2.6.22-rc7 .config too? I'll try and reproduce
this so we can see what went wrong ...


Satyam
