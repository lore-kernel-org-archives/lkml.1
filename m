Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYFRRPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYFRRPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYFRRPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:15:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:17404 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbYFRRP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:15:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,666,1204531200"; 
   d="scan'208";a="398969517"
From: "Luck, Tony" <tony.luck@intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "ksummit-2008-discuss@lists.linux-foundation.org" 
	<ksummit-2008-discuss@lists.linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 18 Jun 2008 10:15:27 -0700
Subject: RE: [Ksummit-2008-discuss] Request for discussion on when to merge
	drivers
Thread-Topic: [Ksummit-2008-discuss] Request for discussion on when to merge
	drivers
Thread-Index: AcjRWTMXRfwXi+YrSBKJpmkIL2v4bgADVfcA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3061C5FA5@orsmsx505.amr.corp.intel.com>
References: <1213802866.3515.24.camel@localhost.localdomain>
In-Reply-To: <1213802866.3515.24.camel@localhost.localdomain>
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

> Experience has shown that for most SCSI drivers, the authors tend to be
> the people producing the hardware and without documentation, no-one else
> can fix up anything other than obvious coding errors, so we can't put it
> in the tree and hope someone else will fix it if they have a problem.

Is there an opportunity for a carrot here ... a driver submitted
*with documentation* gets a faster path into the tree?

-Tony
