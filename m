Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbYKGBQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbYKGBQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYKGBQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:16:23 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:44785 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYKGBQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:16:22 -0500
Date: Thu, 06 Nov 2008 20:15:38 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v3 0/3] ACPI: Fix for supporting > 256 processor
 declaration limit
In-reply-to: <20081104213732.15214.174.stgit@bob.kio>
X-X-Sender: lenb@localhost.localdomain
To: Myron Stowe <myron.stowe@hp.com>
Cc: aystarik@gmail.com, yakui.zhao@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <alpine.LFD.2.00.0811062015250.3106@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081104213732.15214.174.stgit@bob.kio>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Nov 2008, Myron Stowe wrote:

> The following three item patch series fixes an issue with the introduction
> of > 256 processor declaration support: "Allow processor to be declared with
> the Device() instead of Processor()" (git SHA 11bf04c4).
> 
> This version, v3, has no functional changes from the original
> (gmane.linux.acpi.devel/34815).  The changes, based on reviewer comments, are:
>   . a change to the printk verbage (v2),
>   . some additional comments (v2),
>   . augment an existing printk to aid detection of faulty FW (v3).
> 
> Please queue as .29 material.

done.

thanks,
-Len
