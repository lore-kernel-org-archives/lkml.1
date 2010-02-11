Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab0BKWzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:55:16 -0500
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:33233 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757197Ab0BKWzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:55:14 -0500
From: ST <st@iss.tu-darmstadt.de>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: 2.6.33-rc7 problems
Date: Thu, 11 Feb 2010 23:54:51 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-00117-ge28cab4; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201002092306.07449.st@iss.tu-darmstadt.de> <4B7354D9.50909@gmail.com>
In-Reply-To: <4B7354D9.50909@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002112354.51990.st@iss.tu-darmstadt.de>
X-PMX-TU: seen v0.99a by 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.2.11.224821
X-PMX-SPAMCHECK: outgoing mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
> Well, the card reader apparently reports medium not present.. is there
> anything in there? how is it not working?
Just another information: It seems as if *only* the SD Card component of 
the reader is detected. This explains why there are only no medium present
results in the calls. There was no SD card plugged into the usb-reader. The 
others like CF,Xd,MS are not detected as it seems, while the SD Card component 
is indeed working as expected and seen in the log.

ST
