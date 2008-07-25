Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYGYP5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYGYP5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYGYP5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:57:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbYGYP5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:57:17 -0400
Message-ID: <4889F78B.9090202@zytor.com>
Date: Fri, 25 Jul 2008 11:55:55 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: please revert commit 53f1b1433da7eac2607a4a0898a221a4485fd732
 (rtc: push the BKL down into the driver ioctl method)
References: <b6a2187b0807250726n77a0cd6eqb97b817fddc343b9@mail.gmail.com>
In-Reply-To: <b6a2187b0807250726n77a0cd6eqb97b817fddc343b9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> This commit is breaking vmware-6.0.4. Upon booting linux (guest) on
> vmware, the whole vmware environment crashed.

Quality hypervisor we have there...

	-hpa
