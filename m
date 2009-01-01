Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbZAAAPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbZAAAPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 19:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZAAAOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 19:14:11 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:60044 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbZAAAOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 19:14:09 -0500
Date: Wed, 31 Dec 2008 19:14:04 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH, resend] misc: Add dell-wmi driver for hotkey control
In-reply-to: <20081231001445.GA23563@srcf.ucam.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <alpine.LFD.2.00.0812311912390.3854@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081228153128.GC13424@srcf.ucam.org>
 <20081230155035.8224ca86.akpm@linux-foundation.org>
 <20081231001445.GA23563@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > One wonders whether this driver should really live in drivers/input/?

It will live in drivers/platform/x86, per the earlier patch series
that moved the platform drivers out of drivers/misc.

thanks,
-- Len Brown, Intel Open Source Technology Center


