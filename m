Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYJCUAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYJCUAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYJCUAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:00:05 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:24639 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYJCUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:00:04 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 0/9] traps: x86: finalize unification of traps.c
Date: Fri,  3 Oct 2008 22:00:31 +0200
Message-Id: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 03 Oct 2008 21:59:43 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.242; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series unifies traps_32.c and traps_64.c.

Greetings,
    Alexander
