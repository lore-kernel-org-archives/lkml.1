Return-Path: <linux-kernel-owner+w=401wt.eu-S1762783AbYG3PQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762783AbYG3PQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYG3PQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:16:38 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:56474 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752304AbYG3PQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:16:38 -0400
Subject: pro_arm_davinci_watchdog_fix.patch
From: Egorov Evgeny <eegorov@ru.mvista.com>
Reply-To: eegorov@ru.mvista.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 30 Jul 2008 19:15:10 +0400
Message-Id: <1217430910.3371.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-10.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix bug of watchdog driver's write fuction which allow to
prevent wdt timeout.  

[I cann't to send my mail to Maintainer of WDT driver - 


wim@iguana.be
Probably, this address is not valid] 

