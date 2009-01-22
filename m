Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbZAVUs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbZAVUs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZAVUsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:48:17 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:39350 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752077AbZAVUsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:48:17 -0500
Message-ID: <4978DB96.1090104@suse.de>
Date: Thu, 22 Jan 2009 23:48:22 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: boot regression from rc1 to rc2
References: <200901222128.20865.oliver@neukum.org>
In-Reply-To: <200901222128.20865.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Hi,
> 
> 2.6.29-rc2 crashes hard during boot on my laptop.
> I've bisected it down to commit c6cb0e878446c79f42e7833d7bb69ed6bfbb381f
> ACPI: EC: Don't trust ECDT tables from ASUS
> 
> The laptop boots with "acpi=off".
> 
> 	Regards
> 		Oliver
Hi,
Mea culpa, patch is here:
http://bugzilla.kernel.org/show_bug.cgi?id=12493

Regards,
Alex.

