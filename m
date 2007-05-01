Return-Path: <linux-kernel-owner+w=401wt.eu-S1423562AbXEATnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423562AbXEATnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423591AbXEATnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:43:42 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:33751 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423562AbXEATnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:43:41 -0400
Message-ID: <4637986B.4030004@zachcarter.com>
Date: Tue, 01 May 2007 12:43:39 -0700
From: Zach Carter <linux@zachcarter.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: bart@samwel.tk
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] trivial: laptop-mode URL update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


trivial laptop-mode URL update.

Signed-off-by: Zach Carter <linux@zachcarter.com>
---

diff --git a/Documentation/laptop-mode.txt b/Documentation/laptop-mode.txt
index 6f639e3..8b15502 100644
--- a/Documentation/laptop-mode.txt
+++ b/Documentation/laptop-mode.txt
@@ -33,7 +33,7 @@ or anything. Simply install all the files included in this document, and
laptop mode will automatically be started when you're on battery. For
your convenience, a tarball containing an installer can be downloaded at:

-http://www.xs4all.nl/~bsamwel/laptop_mode/tools/
+http://www.samwel.tk/laptop_mode/laptop_mode/

To configure laptop mode, you need to edit the configuration file, which is
located in /etc/default/laptop-mode on Debian-based systems, or in



