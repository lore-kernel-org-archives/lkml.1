Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbXF2Vb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbXF2Vb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbXF2VbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:31:21 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:43997 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbXF2VbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:31:20 -0400
Message-ID: <46857946.20201@gmail.com>
Date: Fri, 29 Jun 2007 23:27:34 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       William D Waddington <william.waddington@beezmo.com>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, Al Boldi <a1426z@gawab.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Please release a stable kernel Linux 3.0
References: <8AH0j-3Qc-11@gated-at.bofh.it> <8AH0j-3Qc-9@gated-at.bofh.it> <8B0vZ-r6-5@gated-at.bofh.it> <8B46G-69z-15@gated-at.bofh.it> <8B52G-7C9-5@gated-at.bofh.it> <8BalK-7Ic-39@gated-at.bofh.it> <8BaYr-8tJ-17@gated-at.bofh.it> <E1I4Nf0-00016f-9A@be1.lrz>
In-Reply-To: <E1I4Nf0-00016f-9A@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2007 11:05 PM, Bodo Eggert wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> Indeed if its public domain you may have almost no rights at all
>> depending what you were given. Once you get the source code you can do
>> stuff but I don't have to give you that. If its public domain I can find
>> security holes in it, and refuse to provide the fixed module in source
>> form even.
> 
> The GPL forces nobody to not release his module under PD, therefore it can't
> protect you from that. Even minor changes - like adjusting the module to use
> to the current API - won't change that, at least in Germany they'd have to
> qualify as a work of their own in order to create a GPL-only derived work,
> because anything not qualifying for that could also be integrated into the
> PD version, and both would remain identical.

What I focussed on when asking were only my wishes as an author but Alan (if 
I understood him right ofcourse) pointed out that _the kernel_ does not want 
integrated code to be in the public domain regardless of my wishes.

Arguably (no doubt, sigh...) someone could distribute the kernel in binary 
form but refuse to provide source for the bits marked as being in the public 
domain alongside it -- yes, can of worms when compared to GPL demands, but I 
believe I can see why one shouldn't even go near there.

Rene.

