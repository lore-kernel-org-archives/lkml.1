Return-Path: <linux-kernel-owner+w=401wt.eu-S1764804AbYEVX5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764804AbYEVX5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759053AbYEVX5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:57:24 -0400
Received: from senator.holtmann.net ([87.106.208.187]:51380 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608AbYEVX5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:57:23 -0400
Cc: maxk@qualcomm.com, linux-kernel@vger.kernel.org
Message-Id: <D2B135C8-8618-4899-AF34-3756C3C1C933@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080522213020.498327ed@core>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] hci_vhci: Elimiate BKL from ioctl handling
Date: Fri, 23 May 2008 01:57:21 +0200
References: <20080522213020.498327ed@core>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> Switch to unlocked_ioctl and fix the return value to be -ENOTTY as it
> should be.
>
> Signed-off-by: Alan Cox <alan@redhat.com>

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

