Return-Path: <linux-kernel-owner+w=401wt.eu-S1031673AbXENLkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031673AbXENLkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030608AbXENLdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:33:15 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27940 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759944AbXENLch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:37 -0400
Message-Id: <20070514110650.866217377@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:50 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFD Patch 0/4] AppArmor - Don't pass NULL nameidata to vfs_create/lookup/permission IOPs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lkml-explanatory.txt

-- 
