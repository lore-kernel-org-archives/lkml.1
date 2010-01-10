Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278Ab0AJPLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0AJPLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 10:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068Ab0AJPLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 10:11:18 -0500
Received: from senator.holtmann.net ([87.106.208.187]:55650 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab0AJPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 10:11:18 -0500
Subject: Re: [PATCH] bluetooth: make USB device id constant
From: Marcel Holtmann <marcel@holtmann.org>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Maxim Krasnyansky <maxk@qualcomm.com>, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
In-Reply-To: <4B49CA73.1080902@freemail.hu>
References: <4B49CA73.1080902@freemail.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jan 2010 07:09:59 -0800
Message-ID: <1263136199.16627.484.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marton,

> From: Márton Németh <nm127@freemail.hu>
> 
> The id_table field of the struct usb_device_id is constant in <linux/usb.h>
> so it is worth to make bcm203x_table also constant.

patch has been applied to my tree. Thanks.

Regards

Marcel


