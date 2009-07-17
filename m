Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbZGQASI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbZGQASI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933739AbZGQASH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:18:07 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:37273 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933745AbZGQASF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:18:05 -0400
MIME-Version: 1.0
X-Originating-IP: [67.185.228.163]
Date: Thu, 16 Jul 2009 17:18:04 -0700
Message-ID: <9f53b4330907161718ydbac090k2afc7a749fc9f6f2@mail.gmail.com>
Subject: SDIO Stack and Device Support
From: Robert Emanuele <rob@emanuele.us>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

I'm trying to find out more information about the status of an SDIO
stack and SDIO devices in the kernel.  I see under drivers/mmc/ some
SDIO support.

I'm evaluating the potential of getting a Wireless SDIO card to work
with the 2.6 kernel.  So far all I see in the kernel is support for an
SDIO UART.  There is a patch on sourceforge for an SDIO stack and
drivers from Atheros but that is for 2.6.18.  Is there current support
for other SDIO wireless devices in the kernel?

Thanks,

Rob
