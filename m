Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbZKQL5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbZKQL5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbZKQL5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:57:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36852 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755042AbZKQL5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:57:49 -0500
Date: Tue, 17 Nov 2009 11:59:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091117115929.4ba23c49@lxorguk.ukuu.org.uk>
In-Reply-To: <20091116175006.GA15157@caffeine.csclub.uwaterloo.ca>
References: <4AF4526B.4060101@zytor.com>
	<40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com>
	<20091109201608.GD15159@caffeine.csclub.uwaterloo.ca>
	<4AF886D4.1080108@zytor.com>
	<20091109212333.GE15159@caffeine.csclub.uwaterloo.ca>
	<20091112121805.GF1394@ucw.cz>
	<20091113162301.GU15157@caffeine.csclub.uwaterloo.ca>
	<20091113165730.0b9b2676@lxorguk.ukuu.org.uk>
	<20091113192412.GY15157@caffeine.csclub.uwaterloo.ca>
	<20091113212148.5cb829d4@lxorguk.ukuu.org.uk>
	<20091116175006.GA15157@caffeine.csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Trying rdmsr from msr-tools 1.2 gives me:
> 
> # ./rdmsr -x 0x00001810
> rdmsr: CPU 0 cannot read MSR 0x00001810
> 
> Hmm, now what?

Beats me - I thought the region registers were read/write.

