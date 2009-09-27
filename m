Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZI0IBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZI0IBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZI0IBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:01:48 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:12383 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZI0IBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:01:47 -0400
Date: Sun, 27 Sep 2009 04:01:48 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Roland Dreier <rdreier@cisco.com>
Cc: ykzhao <yakui.zhao@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Kill overly verbose "power state" log messages
In-reply-to: <adak4znypw8.fsf@cisco.com>
Message-id: <alpine.LFD.2.00.0909270400420.16783@localhost.localdomain>
References: <adapr9gypqz.fsf@cisco.com>
 <1253839597.3609.459.camel@localhost.localdomain> <adak4znypw8.fsf@cisco.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So just delete the code that prints the C-states in processor_idle.c.

applied

thanks,
Len Brown, Intel Open Source Technology Center

