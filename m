Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYCZD1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYCZD1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYCZD1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:27:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42763 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYCZD1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:27:31 -0400
Date: Wed, 26 Mar 2008 04:27:29 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Fei Liu <feiliu4@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: A question to Frank Kingswood about ch340/341 support for 2.4.18
 kernel
In-Reply-To: <47E9B6A9.6010408@gmail.com>
Message-ID: <alpine.LNX.1.10.0803260424130.22661@fbirervta.pbzchgretzou.qr>
References: <47E9B6A9.6010408@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-03-26 03:36, Fei Liu wrote:
>
> Is there any chance this driver [ch341] can be back ported to
> 2.6.18 for opensuse 10.2 system? It seems the usb kernel data
> structures had some significant changes from 2.6.18 to 2.6.24.

They indeed have, and probably not insignificant.

ftp://ftp5.gwdg.de/pub/linux/misc/suser-jengelh/SUSE-10.3/ (and
../SRPMS/) contains ch341-2.6.23.99rc7-1593.{i586,x86_64,src}.rpm for
2.6.23(.17) (and such kernel is available through this repository).
Maybe it helps though you said you have 10.2.
