Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZIOQLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZIOQLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZIOQLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:11:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:35942 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbZIOQLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:11:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="727158225"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       Roland Dreier <rolandd@cisco.com>
Date: Tue, 15 Sep 2009 17:11:21 +0100
Subject: RE: [PATCH 18/18] I/OAT: Convert to PCI_VDEVICE()
Thread-Topic: [PATCH 18/18] I/OAT: Convert to PCI_VDEVICE()
Thread-Index: AcotK2J9UZFMJ8PSSieArvcBE/ySGAI877aA
Message-ID: <129600E5E5FB004392DDC3FB599660D7B55487A0@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064606.7141.40657.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064606.7141.40657.stgit@dwillia2-linux.ch.intel.com>
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

Williams, Dan J wrote:
> From: Roland Dreier <rdreier@cisco.com>
> 
> Trivial cleanup to make the PCI ID table easier to read.
> 
> [dan.j.williams@intel.com: extended to v3.2 devices]
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>