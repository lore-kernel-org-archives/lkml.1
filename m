Return-Path: <linux-kernel-owner+w=401wt.eu-S1751202AbXBROHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbXBROHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 09:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXBROHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 09:07:32 -0500
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3036 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbXBROHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 09:07:31 -0500
Message-ID: <45D85DA1.7090502@xs4all.nl>
Date: Sun, 18 Feb 2007 15:07:29 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PCI riser cards and PCI irq routing, etc
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is there some howto information available about using PCI riser cards
(with multiple PCI slots) under Linux?
Several incarnations exist of PCI riser cards with two PCI slots where
the Device Number of one slot can be changed.
How, based on what information, does Linux assign an IRQ to each card,
plugged into the riser?
How can one tweak/influence the irq routing?
How can I make a dual riser card work so that both cards have a working
interrupt?
Or if stuff should work all by itself, what could be wrong?

Kind regards,
Udo
