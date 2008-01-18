Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbYARJF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbYARJF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYARJFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:05:38 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:60528 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbYARJFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:05:35 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: mathewss@mail.nutech.com, linux-usb@vger.kernel.org
Subject: Re: mos7720. anyone actualy have it wokring?
Date: Fri, 18 Jan 2008 10:07:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <200801171531.AA26017902@mail.nutech.com>
In-Reply-To: <200801171531.AA26017902@mail.nutech.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181007.30144.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 18. Januar 2008 00:31:26 schrieb mathewss:
> This driver for me does not work when i try to cat /dev/ttyUSB2
> it fails and when i try to run
> 
> statserial /dev/ttyUSB2 
> statserial: TIOCMGET failed: Invalid argument

We are always looking for testers. Can you recompile with CONFIG_USB_DEBUG,
provide a log and do an strace of your applications?

	Regards
		Oliver
