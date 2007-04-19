Return-Path: <linux-kernel-owner+w=401wt.eu-S2993103AbXDSBmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993103AbXDSBmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 21:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993104AbXDSBmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 21:42:09 -0400
Received: from dougfood.mirapoint.com ([63.107.133.21]:44291 "EHLO
	dougfood.mirapoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993103AbXDSBmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 21:42:08 -0400
From: <mchu@mirapoint.com>
Subject: PCI: Unable to handle 64-bit address space
 for
To: linux-kernel <linux-kernel@vger.kernel.org>
X-Mailer: Mirapoint Webmail Direct 4.0.0.15-L
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070418184335.AML02030@dougfood.mirapoint.com>
Date: Wed, 18 Apr 2007 18:43:35 -0700 (PDT)
X-Junkmail-Whitelist: YES (by domain whitelist at dougfood.mirapoint.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Anyone has idea of this:  Why it is displayed on boot? How to fix this?  Or at least not to display this message?

Using 2.6.9-42.ELsmp.

PCI: Probing PCI hardware (bus 00)
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
PCI: Unable to handle 64-bit address space for
PCI: Unable to handle 64-bit address space for
PCI: Unable to handle 64-bit address space for
PCI: Unable to handle 64-bit address space for
PCI: Unable to handle 64-bit address space for
PCI: Unable to handle 64-bit address space for
PCI: Unable to handle 64-bit address space for
PCI: Unable to handle 64-bit address space for
PCI: Unable to handle 64-bit address space for


Thanks for the help,

Michael
