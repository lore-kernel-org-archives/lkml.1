Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbYLJFfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbYLJFfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 00:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYLJFf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 00:35:28 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:54650 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYLJFf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 00:35:27 -0500
Date: Wed, 10 Dec 2008 00:35:12 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] /proc/acpi/alarm: handle day-of-month wraparound on
 readback
In-reply-to: <493E92D6.8090104@rtr.ca>
X-X-Sender: lenb@localhost.localdomain
To: Mark Lord <lkml@rtr.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0812100034100.17146@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200806222042.13929.david-b@pacbell.net> <4934176F.6080900@rtr.ca>
 <alpine.LFD.2.00.0812011311490.3197@localhost.localdomain>
 <4934619A.10809@rtr.ca> <493E92D6.8090104@rtr.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (repost)

thanks for the refresh, Mark.
applied to acpi-test.

--
Len Brown, Intel Open Source Technology Center
