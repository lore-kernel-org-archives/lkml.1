Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbYJHEcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbYJHEcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 00:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYJHEcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 00:32:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:9330 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbYJHEcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 00:32:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,377,1220252400"; 
   d="scan'208";a="624629688"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH 1/3] TXT: ACPI AddressRangeUnusuable support
Date: Tue, 7 Oct 2008 21:32:20 -0700
Message-ID: <D936D925018D154694D8A362EEB0892005AC1429@orsmsx416.amr.corp.intel.com>
In-Reply-To: <87iqs3lxdz.fsf@basil.nowhere.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 1/3] TXT: ACPI AddressRangeUnusuable support
Thread-Index: Acko4GZZ64A8RCLMS0KvBTugQJ6KkgAHjitg
References: <D936D925018D154694D8A362EEB0892005AC105D@orsmsx416.amr.corp.intel.com> <87iqs3lxdz.fsf@basil.nowhere.org>
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <linux-kernel@vger.kernel.org>, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Chris Wright" <chrisw@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       <mingo@elte.hu>, <tytso@mit.edu>
X-OriginalArrivalTime: 08 Oct 2008 04:32:22.0540 (UTC) FILETIME=[DB7434C0:01C928FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Tuesday, October 07, 2008 5:54 PM
> 
> "Cihula, Joseph" <joseph.cihula@intel.com> writes:
> > +#define E820_UNUSABLE	5
> >
> >  /* reserved RAM used by kernel itself */
> >  #define E820_RESERVED_KERN        128
> >
> > From: <akpm@linux-foundation.org>
> 
> Something got corrupted? Your patch contains a mailbox with another
> version of the patch.

It appears Outlook/Exchange munged more than just tabs and wrapping.  My
most recent patch should be correct (at least the copy I received looks
fine).

> 
> > Subject: - acpi-add-support-for-addressrangeunusuable-acpi-memory-
> type.patch removed from -mm tree
> > To: "Cihula, Joseph" <joseph.cihula@intel.com>,
> > 	<andi@firstfloor.org>,
> > 	"Wei, Gang" <gang.wei@intel.com>,
> > 	<mingo@elte.hu>,
> > 	"Wang, Shane" <shane.wang@intel.com>,
> > 	<tglx@linutronix.de>,
> > 	<mm-commits@vger.kernel.org>
> > Date: Tue, 26 Aug 2008 11:44:49 -0700
> >
> >
> > The patch titled
> >      acpi: add support for AddressRangeUnusuable ACPI memory type
> > has been removed from the -mm tree.  Its filename was
> >      acpi-add-support-for-addressrangeunusuable-acpi-memory-
> type.patch
> 
> -Andi
> --
> ak@linux.intel.com
