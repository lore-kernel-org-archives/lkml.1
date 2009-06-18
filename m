Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbZFRRNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbZFRRNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZFRRNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:13:39 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:39844 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbZFRRNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:13:38 -0400
Date: Thu, 18 Jun 2009 12:08:18 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
In-reply-to: <4A329CF8.4050502@goop.org>
Message-id: <alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
References: <4A329CF8.4050502@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In principle, the local APIC and the I/O APIC are distinct (but related)
> components, which can be independently present.

bzzzzt, but thanks for playing:-)

Nacked by: Len Brown <len.brown@intel.com>
