Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYFJPe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYFJPe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYFJPes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:34:48 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:40762 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYFJPer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:34:47 -0400
Date: Tue, 10 Jun 2008 11:30:24 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: ACPI: EC: GPE storm detected, disabling EC GPE
In-reply-to: <20080606235526.783acc83.akpm@linux-foundation.org>
X-X-Sender: lenb@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Mattock <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Alexey Starikovskiy <astarikovskiy@suse.de>
Message-id: <alpine.LFD.1.10.0806101128390.14381@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <dd18b0c30806062321x2918f6feq7c817bde52ba0c4c@mail.gmail.com>
 <20080606235526.783acc83.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Could someone from acpi land please help here?

Alexey maintains the EC, and he's supplied 3 patches to test
in the bug report.  The 3rd is awaiting word from Justin.

cheers,
-Len

> Justin, has this machine always had this problem or is it something
> which earlier kernels handled correctly?

note that the EC storm detection is new -- so the failure may
have simply been different in older kernels -- such as a huge
number of ACPI interrupts.

cheers,
-len

