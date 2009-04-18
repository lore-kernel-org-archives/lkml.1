Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZDRRYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZDRRYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 13:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZDRRYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 13:24:14 -0400
Received: from mail.it-technology.at ([62.99.145.147]:46438 "EHLO
	mail.it-technology.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZDRRYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 13:24:13 -0400
Message-ID: <bbff2b8e6400b0db79d3244ea02fba82.squirrel@webmail.it-technology.at>
Date: Sat, 18 Apr 2009 19:24:11 +0200 (CEST)
Subject: [PATCH 0/2] new usb driver int51x1 overview
From: "Peter Holik" <peter@holik.at>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Netdev" <netdev@vger.kernel.org>, linux-usb@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am submitting a series of 2 patches for inclusion in 2.6.30.
Here is a brief description of the patch series:
- because of using the same function get_ethernet_addr as cdc_ether.c
  i export usbnet_get_ethernet_addr from usbnet and fixed cdc_ether (suggested by Oliver Neukum).
- usb driver for intellon int51x1 based PLC like devolo dlan duo
  with improvements suggested by the guys of the mailinglist

cu Peter



