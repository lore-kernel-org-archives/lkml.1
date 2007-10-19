Return-Path: <linux-kernel-owner+w=401wt.eu-S934288AbXJSTvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288AbXJSTvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935674AbXJSTuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:50:06 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:24615 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1764474AbXJSTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:49:59 -0400
Date: Fri, 19 Oct 2007 13:16:23 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/8] EDAC fixes and new drivers
Message-ID: <47190287.Po+E60V88ue02xbr%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

This EDAC patch set was applied against: 2.6.23

1) Enable logging on edac_device class devices
2) round_jiffies_relative instead of round_jiffies
3) New XDR memory and Cell memory controller driver
4) i3000 code tidying
5) freescale driver
6) marvell driver

Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
