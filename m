Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbXLLLwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbXLLLwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbXLLLws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:52:48 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:56275 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbXLLLwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:52:47 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.24-rc4: bluetooth device gone after suspend to ram
Date: Wed, 12 Dec 2007 12:52:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <1197455517.8814.10.camel@localhost>
In-Reply-To: <1197455517.8814.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712121252.54061.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 12. Dezember 2007 11:31:57 schrieb Soeren Sonnenburg:
> Dear all,
> 
> I noticed that on my macbook pro1,1 the bluetooth device is gone after
> suspend to ram, i.e.

Is this a regression?
Does it work if you unload hci_usb before you suspend?
If so, please recompile with CONFIG_USB_DEBUG and provide
dmesg.

	Regards
		Oliver

