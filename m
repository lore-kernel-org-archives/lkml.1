Return-Path: <linux-kernel-owner+w=401wt.eu-S1751709AbXBOXcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbXBOXcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXBOXcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:32:19 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:10576 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbXBOXcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:32:17 -0500
Date: Thu, 15 Feb 2007 17:31:46 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: GPL vs non-GPL device drivers
In-reply-to: <fa.+3hIy95KSdtolNz5kNmm6qk4FU8@ifi.uio.no>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Manu Abraham <abraham.manu@gmail.com>
Message-id: <45D4ED62.9080702@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GPbYGi2HYDPl2WlRgsq2dPbD6cM@ifi.uio.no>
 <fa.5t0XkAtEpB2nDYFPJKUBce9BKFE@ifi.uio.no>
 <fa.upvZMIS42lj8Tbudh1OdnbDn+Ts@ifi.uio.no>
 <fa.821rWTmf8FgAMnDeO7b6yeUeXYg@ifi.uio.no>
 <fa.+3hIy95KSdtolNz5kNmm6qk4FU8@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) wrote:
> There are a lot of device drivers that will never make it into the
> mainline kernel because they are for one-of-a-kind devices or boards
> that companies embed into their products. Nobody would even want a
> copy of the software to interface with something that they would
> never even have. When Version 2.6 started, it became necessary to
> use special tools and procedures to compile a module that was not
> inside the mainline kernel. However, it was still quite easy. Recently,
> somebody, apparently with an advanced degree in obfuscation, has made
> that more difficult. This is abuse, pure and simple. That, in my
> opinion, is one of the major reasons why people who use Linux in
> embedded systems end up using very old versions.

What are you talking about? There's nothing wrong with external module 
compilation in current kernels. You need about a 5-line makefile that 
calls the kernel build system, and it works fine.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

