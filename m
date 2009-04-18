Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbZDRQnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbZDRQnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 12:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZDRQnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 12:43:05 -0400
Received: from mail.it-technology.at ([62.99.145.147]:41197 "EHLO
	mail.it-technology.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZDRQnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 12:43:04 -0400
Message-ID: <5c52681c17a9cd66ec59e9d9cad3ee46.squirrel@webmail.it-technology.at>
In-Reply-To: <Pine.LNX.4.64.0904181834210.3691@wrl-59.cs.helsinki.fi>
References: <cb6d2886e87af66d945f1052e6eb8a85.squirrel@webmail.it-technology.at>
    <Pine.LNX.4.64.0904181311470.3600@wrl-59.cs.helsinki.fi>
    <0681089db5bdc5acc805ed52130dc9a5.squirrel@webmail.it-technology.at>
    <Pine.LNX.4.64.0904181834210.3691@wrl-59.cs.helsinki.fi>
Date: Sat, 18 Apr 2009 18:42:59 +0200 (CEST)
Subject: [PATCH 0/2] usb driver for intellon int51x1 based PLC like devolo 
     dlan duo
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
  i export usbnet_get_ethernet_addr from usbnet and fixed cdc_ether
  (suggested by Oliver Neukum).
- usb driver for intellon int51x1 based PLC like devolo dlan duo
  with improvements suggested by the guys of the mailinglist

cu Peter

