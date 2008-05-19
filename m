Return-Path: <linux-kernel-owner+w=401wt.eu-S1760732AbYESPhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732AbYESPhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYESPgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:36:52 -0400
Received: from main.gmane.org ([80.91.229.2]:60474 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbYESPgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:36:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: linux-next-20080519 does not boot
Date: Mon, 19 May 2008 16:36:31 +0100
Message-ID: <g0s6pv$va4$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to boot this kernel the kernel seems to be going well until it
comes to time to mount disks at which point it starts going very slow. It
doesn't respond to the keyboard (caps lock does not work), sysrq is
inoperable and the ATA tests timeout and over the course of minutes start
negotiating slower speeds. Using nmi_watchdog=1 or nmi_watchdog=2 does not
make any difference. next-20080516 booted correctly.

Config is downloadable from http://sucs.org/~sits/test/config-20080519 .

-- 
Sitsofe

