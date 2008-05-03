Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYECOen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYECOen (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 10:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYECOeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 10:34:00 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:49858 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755399AbYECOd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 10:33:58 -0400
From: monstr@seznam.cz
To: paulus@samba.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: FIXING names for debugfs
Date: Sat,  3 May 2008 16:35:13 +0200
Message-Id: <1209825314-8048-1-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <monstr@seznam.cz>
References: <monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

this patch fix powerpc specific name to arch independent name.
I did these changes because I would like to use prom.c file
for Microblaze.

Thanks for applying this change,
Michal Simek


