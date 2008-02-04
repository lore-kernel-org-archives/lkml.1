Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYBDQGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYBDQGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 11:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYBDQGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 11:06:12 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:39115 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbYBDQGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 11:06:12 -0500
MIME-Version: 1.0
Date: Mon, 4 Feb 2008 10:06:11 -0600
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org
Subject: [REGRESSION] commit 7cbe5b6005f80de33a205d3052cdc89aacaac07c
Message-ID: <5e6165f3196ec6b80a00ac5d5bc51493@felipebalbi.com>
User-Agent: FelipeBalbi.com Webmail
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

commit 7cbe5b6005f80de33a205d3052cdc89aacaac07c broke compilation of
drivers/scsi/lpfc/lpfc_init.c

-- 
Best Regards,

Felipe Balbi
http://felipebalbi.com
me@felipebalbi.com

