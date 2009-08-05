Return-Path: <linux-kernel-owner+w=401wt.eu-S1751389AbZHETSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbZHETSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZHETSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:18:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:51891 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZHETSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:18:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,330,1246863600"; 
   d="scan'208";a="436445542"
From: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
To: Rik van Riel <riel@redhat.com>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Date: Wed, 5 Aug 2009 12:18:48 -0700
Subject: RE: [RFC] respect the referenced bit of KVM guest pages?
Thread-Topic: [RFC] respect the referenced bit of KVM guest pages?
Thread-Index: AcoWAB+jrlA5vaeQTZe/T60Q/QNIRQAAVHkg
Message-ID: <9EECC02A4CC333418C00A85D21E89326B651C21C@azsmsx502.amr.corp.intel.com>
References: <20090805024058.GA8886@localhost> <4A79C70C.6010200@redhat.com>
 <9EECC02A4CC333418C00A85D21E89326B651C1FE@azsmsx502.amr.corp.intel.com>
 <4A79D88E.2040005@redhat.com>
In-Reply-To: <4A79D88E.2040005@redhat.com>
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

> How did you create that 128M memory compartment?
> 
> Did you use cgroups on the host system?

Yup.

> How much memory do you give your virtual machine?
>
> That is, how much memory does it think it has?

256M.

					Jeff

