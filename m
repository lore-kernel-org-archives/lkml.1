Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYLRWm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYLRWm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYLRWms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:42:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:39824 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbYLRWmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:42:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,245,1228118400"; 
   d="scan'208";a="372112179"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Greg KH <greg@kroah.com>, Jike Song <albcamus@gmail.com>,
       "Zhao, Yu" <yu.zhao@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "horms@verge.net.au" <horms@verge.net.au>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Thu, 18 Dec 2008 14:42:38 -0800
Subject: RE: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Thread-Index: Aclgibtj3D4gaS0KQQCQi96EvjTmSgA1/1mA
Message-ID: <43F901BD926A4E43B106BF17856F07554B582F35@orsmsx508.amr.corp.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
 <200812171051.36645.jbarnes@virtuousgeek.org>
 <43F901BD926A4E43B106BF17856F07554B525A02@orsmsx508.amr.corp.intel.com>
 <200812171142.56170.jbarnes@virtuousgeek.org>
In-Reply-To: <200812171142.56170.jbarnes@virtuousgeek.org>
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

Jesse Barnes wrote:
> 
> Hm, that's not the answer I was hoping for. :)  (Was looking for,
> "Yeah we just need this bits queued and we'll send an update for
> e1000 right away." :) 
> 
> I really don't want the SR-IOV stuff to sit out another merge cycle
> though... Arg.

We will have drivers that support these API's posted to the 
lists within two or three days.  These drivers are RFC only 
and not to be pushed upstream.  More non-Xen testing needs to 
happen with the 82576 HW.

- Greg

