Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYLUOTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYLUOTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYLUOTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:19:10 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:29783 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbYLUOTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:19:09 -0500
Date: Sun, 21 Dec 2008 16:19:01 +0200 (IST)
From: Matan Ziv-Av <matan@svgalib.org>
X-X-Sender: matan@matan.home
To: arrow.ebd@gmail.com
cc: linux_kernel <linux-kernel@vger.kernel.org>,
       frank@kingswood-consulting.co.uk
Subject: Re: usb-serial: how to let ch341 work with baudrate 57600 ?
In-Reply-To: <20081221032746.GA4502@think>
Message-ID: <alpine.LFD.2.00.0812211611210.11887@matan.home>
References: <20081221032746.GA4502@think>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Dec 2008, arrow.ebd@gmail.com wrote:

> dear frank,
>
> 	I have a USB-to-RS232 connector with chip ch341, but it
> can not work under baud rate 57600.
>
> 	I checked baud rate is set in function "ch341_set_baudrate".
>
> 	How can I setup it with baudrate 57600 ?
>
> 	I would like hear from you, Or give me some suggestion
> to hack it.

See here: http://lkml.org/lkml/2008/9/21/17 for a patch that allows 
arbitrary baud rate.


-- 
Matan Ziv-Av.                         matan@svgalib.org


