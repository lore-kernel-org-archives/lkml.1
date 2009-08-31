Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZHaULz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZHaULz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 16:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZHaULz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 16:11:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:51951 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbZHaULy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 16:11:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,307,1249282800"; 
   d="scan'208";a="489100616"
From: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
To: Rik van Riel <riel@redhat.com>
CC: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>, Avi Kivity <avi@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Date: Mon, 31 Aug 2009 13:11:45 -0700
Subject: RE: [RFC] respect the referenced bit of KVM guest pages?
Thread-Topic: [RFC] respect the referenced bit of KVM guest pages?
Thread-Index: AcoqdwGehfNtmn2WSyG7IqN+xYyR6wAACS8w
Message-ID: <9EECC02A4CC333418C00A85D21E893260184183346@azsmsx502.amr.corp.intel.com>
References: <4A7AAE07.1010202@redhat.com>
 <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost>
 <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost>
 <4A7AD79E.4020604@redhat.com> <20090816032822.GB6888@localhost>
 <4A878377.70502@redhat.com> <20090816045522.GA13740@localhost>
 <9EECC02A4CC333418C00A85D21E89326B6611F25@azsmsx502.amr.corp.intel.com>
 <20090821182439.GN29572@balbir.in.ibm.com>
 <9EECC02A4CC333418C00A85D21E8932601841832F9@azsmsx502.amr.corp.intel.com>
 <4A9C2A17.3080802@redhat.com>
 <9EECC02A4CC333418C00A85D21E893260184183339@azsmsx502.amr.corp.intel.com>
 <4A9C2E01.7080707@redhat.com>
In-Reply-To: <4A9C2E01.7080707@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Page discards by the host, which are invisible to the guest
> OS.

Duh.  Right - I can't keep my VM systems straight...

					Jeff

