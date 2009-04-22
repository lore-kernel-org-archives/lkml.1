Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZDVMwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZDVMwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 08:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZDVMvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 08:51:51 -0400
Received: from langos.euedge.com ([209.190.22.130]:58864 "EHLO
	langos.euedge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZDVMvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:51:50 -0400
Message-ID: <49EF12E3.5010800@maroy.hu>
Date: Wed, 22 Apr 2009 14:51:47 +0200
From: =?UTF-8?B?TWFyw7N5IMOBa29z?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
References: <49EDC44D.90106@maroy.hu> <200904211539.23671.oliver@neukum.org> <49EDFA80.9060305@maroy.hu> <200904211952.25616.oliver@neukum.org>
In-Reply-To: <200904211952.25616.oliver@neukum.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

I saw this post: http://marc.info/?l=linux-usb&m=123921902417985&w=2

and tried the same as described there:

- blacklisted cdc-acm
- loaded the usbserial module manually

and I get a /dev/ttyUSB0 device, and it works like a charm..

(this is on ubunutu's 2.6.27 kernel, for some reason they don't have the
usbserial module on their 2.6.28 kernel)


Sorry for dripping information in small chunks...


Akos
