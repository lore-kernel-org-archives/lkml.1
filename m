Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbXJQViX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbXJQViX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932646AbXJQVhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:37:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:33035 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbXJQVhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:37:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="249505277"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 0/3] vmcoreinfo support for dump filtering
Date: Wed, 17 Oct 2007 14:32:21 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A02B57FA2@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20071017132018.218043bb.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/3] vmcoreinfo support for dump filtering
Thread-Index: AcgQ+yub5svsukAXSh6dlQ88u4q1ggACc7mQ
References: <20070822210838oomichi@mail.jp.nec.com><12c511ca0710171019t35cb1670k9e1bdcfb3bf99793@mail.gmail.com> <20071017132018.218043bb.akpm@linux-foundation.org>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <oomichi@mxs.nes.nec.co.jp>, <linux-kernel@vger.kernel.org>,
       <kexec@lists.infradead.org>, <nhorman@redhat.com>, <vgoyal@in.ibm.com>,
       <bwalle@suse.de>, <dzickus@redhat.com>, <da-x@monatomic.org>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 17 Oct 2007 21:32:22.0036 (UTC) FILETIME=[33B97540:01C81105]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This?

That does the trick, yes.

> (please tell me if you want me to send this to Linus)

I've put it in my tree now ... so I'll ask Linus to pull
it from there.

-Tony
