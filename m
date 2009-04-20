Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZDTX7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZDTX7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZDTX7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:59:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:57980 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZDTX7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:59:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,220,1239001200"; 
   d="scan'208";a="449690077"
From: "Luck, Tony" <tony.luck@intel.com>
To: Randy Dunlap <randy.dunlap_ocs10g@oracle.com>
CC: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 Apr 2009 16:59:27 -0700
Subject: RE: linux-next ia64 build problems in slqb
Thread-Topic: linux-next ia64 build problems in slqb
Thread-Index: AcnCEaqr+7x29n4KTay5tAEYVASmtwAAdzJA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39EC571B4@orsmsx505.amr.corp.intel.com>
References: <49ecf25e2378234eed@agluck-desktop.sc.intel.com>
 <49ED0869.5090507@oracle.com>
In-Reply-To: <49ED0869.5090507@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does this patch fix it?
>
> http://lkml.org/lkml/2009/4/20/30

That makes all the compilation errors go away from
the allnoconfig build.  Build still seems OK on
a more conventional .config (tiger_defconfig).

I haven't tried booting this kernel though, so
I don't know whether slqb works or not. Perhaps
I'll get brave and try that tomorrow.

-Tony

