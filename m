Return-Path: <linux-kernel-owner+w=401wt.eu-S1751308AbZIIECU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbZIIECU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 00:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbZIIECT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 00:02:19 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:53987 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZIIECS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 00:02:18 -0400
Date: Wed, 09 Sep 2009 00:02:03 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Zhang Rui <rui.zhang@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: linux-next: acpi tree build failure
In-reply-to: <1252370869.3483.420.camel@rzhang-dt>
Message-id: <alpine.LFD.2.00.0909082359480.20206@localhost.localdomain>
References: <20090901125748.fb33b2ea.sfr@canb.auug.org.au>
 <20090907234612.078bb650.sfr@canb.auug.org.au>
 <1252370869.3483.420.camel@rzhang-dt>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> please revert the two ALS patches.

done.

Sorry about the merge-conflict and build error, Stephen.
You can update to the latest acpi-test tree now.

thanks,
-Len Brown, Intel Open Source Technology Center

