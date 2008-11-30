Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbYK3FLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbYK3FLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 00:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYK3FLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 00:11:44 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:42313 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYK3FLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 00:11:43 -0500
Date: Sun, 30 Nov 2008 00:11:36 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: EC: fix compilation warning
In-reply-to: <493199A4.5020203@suse.de>
X-X-Sender: lenb@localhost.localdomain
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Hannes Eder <hannes@hanneseder.net>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Message-id: <alpine.LFD.2.00.0811300010570.3239@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <49318541.0aec660a.0efb.3436@mx.google.com>
 <493199A4.5020203@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 29 Nov 2008, Alexey Starikovskiy wrote:

> Hannes Eder wrote:
> > Fix the warning introduced in commit
> > c5279dee26c0e8d7c4200993bfc4b540d2469598,
> > and give the dummy variable a more verbose name.
> Thanks!
> > 
> >   drivers/acpi/ec.c: In function 'acpi_ec_ecdt_probe':
> >   drivers/acpi/ec.c:1015: warning: ISO C90 forbids mixed declarations and
> > code
> > 
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>

applied on top of 11880 fix in acpi-test.

thanks,
-len

