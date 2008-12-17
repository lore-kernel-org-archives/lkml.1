Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752539AbYLQTnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbYLQTnP (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYLQTmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:42:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:33523 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbYLQTmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:42:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,238,1228118400"; 
   d="scan'208";a="650625629"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, "Zhao, Yu" <yu.zhao@intel.com>,
        "Yu, Wilfred" <wilfred.yu@intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
        "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
        Greg KH <greg@kroah.com>, "rdreier@cisco.com" <rdreier@cisco.com>,
        Jike Song <albcamus@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>
Date: Wed, 17 Dec 2008 11:42:47 -0800
Subject: RE: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Thread-Index: AclgfotYlD5H0qChT9uopyth59+c9gAAEugw
Message-ID: <43F901BD926A4E43B106BF17856F07554B525A62@orsmsx508.amr.corp.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
	<20081217060608.GA12618@kroah.com>
	<43F901BD926A4E43B106BF17856F07554B525811@orsmsx508.amr.corp.intel.com>
	<200812171051.36645.jbarnes@virtuousgeek.org>
 <43F901BD926A4E43B106BF17856F07554B525A02@orsmsx508.amr.corp.intel.com>
 <49495447.5030904@goop.org>
In-Reply-To: <49495447.5030904@goop.org>
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



Jeremy Fitzhardinge wrote:

> Which dom0 kernel are you using?  Is it based on my pvops-based dom0 work?

The kernel I'm currently using is an ad-hoc patchwork of changes to the 2.6.18 Xen Dom0 kernel that was available back in August.  The folks from OTC in Intel (Zhao Yu and his team) would be able to provide you more background on it as they did the work to enable MSI-X, SR-IOV and VT-d in that kernel so that my drivers would function.  I don't see Zhao Yu on the distro list for this email so I'll add him.

- Greg

