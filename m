Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbZAZLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbZAZLtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 06:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZAZLtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 06:49:10 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:53854 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZAZLtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 06:49:09 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Ed W <lists@wildgooses.com>, linux-usb@vger.kernel.org
Subject: Re: How to add new CDC-ACM usb modem device to supported list?
Date: Mon, 26 Jan 2009 12:49:37 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <497D94C0.3070308@wildgooses.com>
In-Reply-To: <497D94C0.3070308@wildgooses.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901261249.37711.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 26 January 2009 11:47:28 schrieb Ed W:
> Hi, I have a wireless modem device which I believe to be a normal usb
> ACM modem type device (works this way in windows where there is just a
> .inf file supplied which connects the device with usbser.sys).  I'm not
> quite sure how to get the 2.6 kernel to notice and connect the acm
> driver to this device though?  I have poked through the code in

It should be detected as is. Please provide dmesg.

	Regards
		Oliver
