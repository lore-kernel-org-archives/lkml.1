Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXA3OS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXA3OS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965487AbXA3OS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:18:26 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:36346 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965485AbXA3OSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:18:25 -0500
Date: Tue, 30 Jan 2007 15:12:54 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
In-Reply-To: <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6>
Message-ID: <Pine.LNX.4.61.0701301512200.1147@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
 <45BF3954.8050106@yahoo.com.au> <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> Why the qualifier? Zero *is* not a power of 2, is it?

No, it is not:

	In[1]:= Solve[2^n == 0, n]

	Out[1]= {}

So says Mathematica5.



Jan
-- 
ft: http://freshmeat.net/p/chaostables/
