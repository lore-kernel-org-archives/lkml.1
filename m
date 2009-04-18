Return-Path: <linux-kernel-owner+w=401wt.eu-S1751547AbZDREBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbZDREBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 00:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbZDREBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 00:01:45 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:40401 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZDREBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 00:01:45 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_IoEjqsCKiwZSSr7lsZweqw)"
Date: Sat, 18 Apr 2009 00:01:30 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] toshiba-acpi: Add support for hotkey notifications
In-reply-to: <20090331214501.GC29489@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.0904180000330.30751@localhost.localdomain>
References: <20090331214501.GC29489@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_IoEjqsCKiwZSSr7lsZweqw)
Content-type: TEXT/PLAIN; charset=ISO-8859-7
Content-transfer-encoding: 8BIT

drivers/platform/x86/toshiba_acpi.c:854: warning: passing argument 3 of 
¡acpi_install_notify_handler¢ from incompatible pointer type
drivers/platform/x86/toshiba_acpi.c:903: warning: passing argument 3 of 
¡acpi_remove_notify_handler¢ from incompatible pointer type

--Boundary_(ID_IoEjqsCKiwZSSr7lsZweqw)--
