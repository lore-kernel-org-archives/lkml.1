Return-Path: <linux-kernel-owner+w=401wt.eu-S966091AbXBOQfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966091AbXBOQfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966089AbXBOQfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:35:45 -0500
Received: from [209.190.27.106] ([209.190.27.106]:44974 "EHLO
	wombat.diezmil.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966083AbXBOQfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:35:44 -0500
X-Greylist: delayed 2908 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 11:35:44 EST
Date: Thu, 15 Feb 2007 10:47:16 -0500
Message-ID: <30987167.1171554435992.JavaMail.root@wombat.diezmil.com>
From: cedric.hertault@v2plus.com
Reply-To: cedric.hertault@v2plus.com
To: linux-kernel@vger.kernel.org
Subject: Re: [IPV4]: Increase number of possible routing tables to 2^32
In-Reply-To: <200609240001.k8O01VL7008533@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It is all I need ! no more 256 routing tables limitation !. But now it is time for me to test it, but i am working on a kernel 2.6.9, do you think it will be good ?

Why do I need so much routing tables? I need more than 500 routing tables because my Linux have to work with 500 VLANs !. Do you think that your patch will be integreted in the Linux kernel or it stays limited at 256?

A very happy kernel noob :)

Cedric Hertault

--
This message was sent on behalf of cedric.hertault@v2plus.com at openSubscriber.com
http://www.opensubscriber.com/message/linux-kernel@vger.kernel.org/4967197.html
