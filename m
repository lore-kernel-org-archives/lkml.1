Return-Path: <linux-kernel-owner+w=401wt.eu-S1751387AbZH0Rbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbZH0Rbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZH0Rbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:31:51 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:41780 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZH0Rbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:31:50 -0400
Date: Thu, 27 Aug 2009 13:31:46 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rui.zhang@intel.com, stable@kernel.org
Subject: Re: [PATCH 1/2] ACPI processor: force throttling state when BIOS
 returns incorrect value
In-reply-to: <20090819115855.193ea8bb.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0908271329160.7792@localhost.localdomain>
References: <200908171443.35622.elendil@planet.nl>
 <20090819115855.193ea8bb.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Did this just fall through the cracks

yes, during summer vacation, the cracks can sometimes be large.

Thanks for handling this one Andrew.

-Len Brown, Intel Open Source Technology Center

ps. lenb@intel.com isn't my e-mail address.
