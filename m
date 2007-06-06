Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbXFFQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbXFFQ5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXFFQ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:57:12 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:36929 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbXFFQ5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:57:12 -0400
Date: Wed, 6 Jun 2007 18:56:20 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Size of kernel modules
In-Reply-To: <9a8748490706060851g59f3043ah82a0390ffc2b290b@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0706061856040.1547@yvahk01.tjqt.qr>
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
 <9a8748490706060851g59f3043ah82a0390ffc2b290b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 6 2007 17:51, Jesper Juhl wrote:
> On 06/06/07, Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de> wrote:
>> Hello,
>> 
>> I have a machine here which I installed with Ubuntu 7.04. Immediately
>> after the installation had been finished, I installed the Ubuntu package
>> which contains the Ubuntu-modified sources of the linux kernel. I
>> extracted the resulting tar.bz2-file, copied the configuration of the
>> currently running kernel to .config and created a file localversion-irb
>> which contains the line "-irb" and then called "make menuconfig".
>
> You forgot "make oldconfig". When you copy in a .config file from a
> different kernel, always do oldconfig (just get in the habbit, if the
> .config from the same kernel it's harmless).

oldconfig is automatically called AFAICS.


	Jan
-- 
