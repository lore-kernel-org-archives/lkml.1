Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbZLVIoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbZLVIoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbZLVIoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:44:12 -0500
Received: from senator.holtmann.net ([87.106.208.187]:51618 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZLVIoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:44:11 -0500
Subject: Re: [PATCH 04/10] bluetooth: add __init/__exit macros to
 drivers/bluetooth/btmrvl_sdio.c
From: Marcel Holtmann <marcel@holtmann.org>
To: peterhuewe@gmx.de
Cc: Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org,
       Bing Zhao <bzhao@marvell.com>, Ben Hutchings <ben@decadent.org.uk>,
       =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       Julia Lawall <julia@diku.dk>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1261470861-23988-1-git-send-email-peterhuewe@gmx.de>
References: <1261470861-23988-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 00:43:42 -0800
Message-Id: <1261471422.4041.200.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of
> 
> drivers/bluetooth/btmrvl_sdio.c
> 
> Please have a look at the small patch and either pull it through
> your tree, or please ack' it so Jiri can pull it through the trivial
> tree.

patch has been applied to my tree. Thanks.

Regards

Marcel


