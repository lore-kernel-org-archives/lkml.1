Return-Path: <linux-kernel-owner+w=401wt.eu-S965566AbYEBPyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965566AbYEBPyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964913AbYEBPv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:51:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38982 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964780AbYEBPvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:51:52 -0400
Subject: [PATCH 0/13] Updated V4  - Regulator Framework
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 16:40:41 +0100
Message-Id: <1209742841.12502.40.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the kernel voltage & current regulator
framework based on comments received from version 3 of the patch series.

The regulator framework is designed to provide a standard kernel
interface to control voltage and current regulators on SoC based
systems.

The intention is to allow systems to dynamically control regulator power
output in order to save power and prolong battery life. This applies to
both voltage regulators (where voltage output is controllable) and
current sinks (where current limit is controllable).

Liam

