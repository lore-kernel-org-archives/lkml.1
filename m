Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbZF2Qft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbZF2Qft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZF2Qfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:35:42 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:41507 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZF2Qfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:35:41 -0400
Date: Mon, 29 Jun 2009 12:35:35 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Feng Tang <feng.tang@intel.com>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
In-reply-to: <alpine.LFD.2.00.0906291204020.5716@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0906291224320.8319@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F07556412B7E8@orsmsx508.amr.corp.intel.com>
 <20090626070720.GB14078@elte.hu>
 <43F901BD926A4E43B106BF17856F0755641A44CB@orsmsx508.amr.corp.intel.com>
 <20090629105933.56c6336f@feng-desktop>
 <alpine.LFD.2.00.0906291204020.5716@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I vote #2 -- remove the #ifdefs.

er, that was option #1 -- sorry if that was confusing.

in any case, i've updated the SFI series to not touch io_apic.h at all,
and that can be done by the x86/ioapic series.

thanks,
-Len

