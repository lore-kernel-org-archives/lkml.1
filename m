Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZDUQzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZDUQzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZDUQzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:55:33 -0400
Received: from langos.euedge.com ([209.190.22.130]:60846 "EHLO
	langos.euedge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZDUQzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:55:32 -0400
Message-ID: <49EDFA80.9060305@maroy.hu>
Date: Tue, 21 Apr 2009 18:55:28 +0200
From: =?UTF-8?B?TWFyw7N5IMOBa29z?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
References: <49EDC44D.90106@maroy.hu> <200904211526.34199.oliver@neukum.org> <49EDCB0F.3040802@maroy.hu> <200904211539.23671.oliver@neukum.org>
In-Reply-To: <200904211539.23671.oliver@neukum.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Olvier,

>>> Could you get dmesg of 2.6.2(7/9) with CONFIG_USB_DEBUG and debug
>>> activated in drivers/usb/class/cdc-acm.c ?

FYI, I compiled 2.6.29.1, and it doesn't work with this kernel either.

I'll compiple with the above flag, and will provide output. should I
just paste dmesg for when the cdc-acm module is loaded?


Akos

