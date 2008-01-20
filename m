Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYATS6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYATS6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbYATS6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:58:00 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:50736 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbYATS57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:57:59 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: [Resending PATCH 5/5] Make otg tpl come from platform_data
Date: Sun, 20 Jan 2008 20:59:58 +0200
Message-Id: <1200855599-17509-1-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.5.4.rc3.24.gb53139
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This resend removes a section mismatch error which could cause troubles in future.

Disconsider the previous patch please.

Best regards,

Felipe Balbi
me@felipebalbi.com

