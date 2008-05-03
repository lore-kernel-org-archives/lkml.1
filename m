Return-Path: <linux-kernel-owner+w=401wt.eu-S1761427AbYECPWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427AbYECPWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761156AbYECPWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:22:17 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54358 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757495AbYECPVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:21:48 -0400
From: monstr@seznam.cz
To: paulus@samba.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Moving OF firware to arch independent folder
Date: Sat,  3 May 2008 16:22:10 +0200
Message-Id: <1209824532-7939-1-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <monstr@seznam.cz>
References: <monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

these patches clean some coding style violation and move 
of_device.c and of_platform.c files to drivers/of/ folder.

I would like to use these files for Microblaze.

Thanks for applying,
Michal Simek


