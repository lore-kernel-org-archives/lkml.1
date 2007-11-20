Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbXKTHxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbXKTHxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbXKTHxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:53:47 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:54562 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbXKTHxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:53:46 -0500
Date: Tue, 20 Nov 2007 08:17:18 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: netdev@vger.kernel.org
Subject: netconsole=y and rtl8139=m
Message-ID: <Pine.LNX.4.64.0711200815220.32378@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



I get this during boot:

[   40.821740] netconsole: eth1 doesn't exist, aborting.

Given that CONFIG_NETCONSOLE=y and CONFIG_8139TOO=m, I can imagine.
Is there a way to get this working without making 8139TOO=y or 
NETCONSOLE=m?



thanks,
Jan
