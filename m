Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYDRPSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYDRPSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 11:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYDRPSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 11:18:18 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:65170 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751380AbYDRPSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 11:18:18 -0400
Date: Fri, 18 Apr 2008 16:18:16 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] dontdiff: add modules.order
Message-ID: <20080418151816.GA18030@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add modules.order to the list of files that
shoud be ignored when using diff on a built
kernel tree.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

diff -rup linux-2.6.25/Documentation/dontdiff linux-2.6.25-dontdiff/Documentation/dontdiff
--- linux-2.6.25/Documentation/dontdiff	2008-04-17 09:48:05.000000000 +0100
+++ linux-2.6.25-dontdiff/Documentation/dontdiff	2008-04-18 16:16:45.000000000 +0100
@@ -142,6 +142,7 @@ mkprep
 mktables
 mktree
 modpost
+modules.order
 modversions.h*
 offset.h
 offsets.h



