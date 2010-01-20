Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890Ab0ATErX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab0ATErX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 23:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765Ab0ATErW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 23:47:22 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:35544 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0ATErV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 23:47:21 -0500
Date: Tue, 19 Jan 2010 23:47:19 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: processor: restrict early _PDC to opt-in platforms
In-reply-to: <20100119235541.GL11010@ldl.fc.hp.com>
Message-id: <alpine.LFD.2.00.1001192344240.4265@localhost.localdomain>
References: <20100119235541.GL11010@ldl.fc.hp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for the focused patch, Alex.

If we expect to run into this issue more, perhaps
we should add a modparam to help handle debugging
and 2.6.33 DMI list maintenance.  The param and
the DMI list can both go away when we think we have
the real fix in 2.6.34.

applied.

thanks,
Len Brown, Intel Open Source Technology Center

