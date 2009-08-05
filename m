Return-Path: <linux-kernel-owner+w=401wt.eu-S933932AbZHEPpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbZHEPpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbZHEPpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:45:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:64106 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933892AbZHEPpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:45:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,329,1246863600"; 
   d="scan'208";a="714155613"
From: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
To: Avi Kivity <avi@redhat.com>, "Wu, Fengguang" <fengguang.wu@intel.com>
CC: Rik van Riel <riel@redhat.com>, "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Date: Wed, 5 Aug 2009 08:45:04 -0700
Subject: RE: [RFC] respect the referenced bit of KVM guest pages?
Thread-Topic: [RFC] respect the referenced bit of KVM guest pages?
Thread-Index: AcoVoc5W8FWBVCWFSQ6v990sVR2dewAQbNag
Message-ID: <9EECC02A4CC333418C00A85D21E89326B651C07C@azsmsx502.amr.corp.intel.com>
References: <20090805024058.GA8886@localhost> <4A793B92.9040204@redhat.com>
In-Reply-To: <4A793B92.9040204@redhat.com>
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

> Jeff, do you see the refaults on Nehalem systems?

My test box is pre-Nehalem - no EPT.

					Jeff
