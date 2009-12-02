Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZLBXS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZLBXS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbZLBXSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:18:55 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:58355 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbZLBXSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:18:55 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Justin Mattock <justinmattock@gmail.com>
Subject: Re: root hub lost power or was reset
Date: Thu, 3 Dec 2009 00:19:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Linux-usb" <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <dd18b0c30912021434t4a247646q48f32c0d0e40faae@mail.gmail.com>
In-Reply-To: <dd18b0c30912021434t4a247646q48f32c0d0e40faae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912030019.07694.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 2. Dezember 2009 23:34:30 schrieb Justin Mattock:

> for a bit I thought that this was also the cause of the delay
> but the system wakes up as it should even with this happening to
> usb.

Perhaps something does an operation that needs to time out.
Which drivers have you loaded when it works and when it doesn't work?

> BTW: Is CONFIG_USB_PERSIST in the kernel anymore
> with 2.6.32*?(I can't seem to find that option);

It is always used and switched on by default.

	Regards
		Oliver
