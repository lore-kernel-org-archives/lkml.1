Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbZICPLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbZICPLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 11:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZICPLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 11:11:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42016 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbZICPLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 11:11:44 -0400
Message-ID: <52241.192.168.10.89.1251990701.squirrel@dbdmail.itg.ti.com>
Date: Thu, 3 Sep 2009 20:41:41 +0530 (IST)
Subject: [PATCH 0/2] mfd: restoring twl4030 power-off and power-button 
     capabilities
From: "vimal singh" <vimalsingh@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series restores the TWL Power-button and Power-off capabilities.
Which were removed in "REMOVE OMAP LEGACY CODE" patches.

Patches are compile tested only.

[PATCH 1/2]: twl4030: register twl4030-pwrbuttonas a child of twl4030-core.c
[PATCH 2/2]: twl4030: initialization of pm_power_off in twl4030-core.c

Both patches are based on Felipe Balbi's patches posted earlier.
http://lkml.org/lkml/2009/2/28/88
http://markmail.org/message/ts4if3553qnauket

--
Vimal




