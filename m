Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbZC0VAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbZC0VAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZC0VAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:00:43 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:42752 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbZC0VAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:00:42 -0400
Date: Fri, 27 Mar 2009 17:00:33 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] acpi: remove the wrong warning about
 xpm1a_event_block.bit_width
In-reply-to: <49C017D0.6030502@kernel.org>
Message-id: <alpine.LFD.2.00.0903271700100.26419@localhost.localdomain>
References: <49C017D0.6030502@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning is not present in the latest ACPICA branch.

thanks,
Len Brown, Intel Open Source Technology Center

