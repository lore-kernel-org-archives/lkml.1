Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbXLLBTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbXLLBTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbXLLBTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:19:09 -0500
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:60650 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbXLLBTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:19:07 -0500
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFT] Port 0x80 I/O speed
Date: Wed, 12 Dec 2007 01:19:02 +0000
User-Agent: KMail/1.9.7
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
References: <475F1DC6.5090403@keyaccess.nl>
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712120119.02356.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2007 23:31:18 Rene Herman wrote:
> Good day.
>
> Would some people on x86 (both 32 and 64) be kind enough to compile and run
> the attached program? This is about testing how long I/O port access to
> port 0x80 takes. It measures in CPU cycles so CPU speed is crucial in
> reporting.

cycles: out 2712, in 2606

1.5GHz C7, Via chipset. 32bit OS.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
