Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbYEEOFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbYEEOFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYEEOEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:04:53 -0400
Received: from bay0-omc2-s25.bay0.hotmail.com ([65.54.246.161]:28863 "EHLO
	bay0-omc2-s25.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbYEEOEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:04:52 -0400
Message-ID: <BAY103-DAV8BAEA75DC17C9A9C29408B2D70@phx.gbl>
X-Originating-IP: [85.32.103.134]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <E1Jrtxr-0004in-00@gondolin.me.apana.org.au>
Subject: Re: 2.6.25 crash: EIP: [<c02e2f14>] xfrm_output_resume+0x64/0x100 ss:esp 0068:c03a1e5c
Date: Mon, 5 May 2008 16:01:46 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 05 May 2008 14:04:10.0633 (UTC) FILETIME=[E43ABF90:01C8AEB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:

> Perhaps you could enable SLAB debugging to see if we can get
> closer to the culprit? Alternatively you could try a git bisection.

I don't know if this is the same bug or something else.
This is a different box but same hw/.config

http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1969.html


