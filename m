Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYGOTVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYGOTVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762862AbYGOTUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:20:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762834AbYGOTUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:20:48 -0400
Date: Tue, 15 Jul 2008 12:19:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Theodore Tso <tytso@mit.edu>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487CF70C.1030309@garzik.org>
Message-ID: <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org>
 <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <487CEA73.9000408@garzik.org> <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org> <487CF01E.6000208@garzik.org> <20080715185801.GH8185@mit.edu>
 <487CF70C.1030309@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Jeff Garzik wrote:
> 
> Already started, in fact, since Linus said he would not reject it out of
> hands.

Btw, I need to see it actually solve a real problem. As it is, I really 
think you've just painted yourself into a corner where you can't just 
admit that we can just load the firmware directly.

Could you _please_ entertain at least thinking about that option?

		Linus
