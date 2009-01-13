Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbZAMRom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbZAMRom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 12:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZAMRod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 12:44:33 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:29355 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZAMRoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 12:44:32 -0500
Message-ID: <496CD2F8.1060403@oracle.com>
Date: Tue, 13 Jan 2009 09:44:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sameo@openedhand.com
Subject: mfd in current mainline 2.6.29-rc1-git3 build errors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.496CD2FB.023F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386 & x86_64 allmodconfig builds fail with:

ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!

-- 
~Randy
