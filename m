Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbYJHAyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbYJHAyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbYJHAyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:54:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45213 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296AbYJHAyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:54:18 -0400
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: <linux-kernel@vger.kernel.org>, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Chris Wright" <chrisw@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       <mingo@elte.hu>, <tytso@mit.edu>
Subject: Re: [RFC][PATCH 1/3] TXT: ACPI AddressRangeUnusuable support
From: Andi Kleen <andi@firstfloor.org>
References: <D936D925018D154694D8A362EEB0892005AC105D@orsmsx416.amr.corp.intel.com>
Date: Wed, 08 Oct 2008 02:54:16 +0200
In-Reply-To: <D936D925018D154694D8A362EEB0892005AC105D@orsmsx416.amr.corp.intel.com> (Joseph Cihula's message of "Tue, 7 Oct 2008 13:34:47 -0700")
Message-ID: <87iqs3lxdz.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Cihula, Joseph" <joseph.cihula@intel.com> writes:
> +#define E820_UNUSABLE	5
>  
>  /* reserved RAM used by kernel itself */
>  #define E820_RESERVED_KERN        128
>
> From: <akpm@linux-foundation.org>

Something got corrupted? Your patch contains a mailbox with another
version of the patch.

> Subject: - acpi-add-support-for-addressrangeunusuable-acpi-memory-type.patch removed from -mm tree
> To: "Cihula, Joseph" <joseph.cihula@intel.com>,
> 	<andi@firstfloor.org>,
> 	"Wei, Gang" <gang.wei@intel.com>,
> 	<mingo@elte.hu>,
> 	"Wang, Shane" <shane.wang@intel.com>,
> 	<tglx@linutronix.de>,
> 	<mm-commits@vger.kernel.org>
> Date: Tue, 26 Aug 2008 11:44:49 -0700
>
>
> The patch titled
>      acpi: add support for AddressRangeUnusuable ACPI memory type
> has been removed from the -mm tree.  Its filename was
>      acpi-add-support-for-addressrangeunusuable-acpi-memory-type.patch

-Andi
-- 
ak@linux.intel.com
