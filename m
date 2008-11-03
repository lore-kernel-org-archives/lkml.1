Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYKCVsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYKCVsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYKCVsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:48:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:42178 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbYKCVsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:48:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,538,1220252400"; 
   d="scan'208";a="70192422"
From: "Luck, Tony" <tony.luck@intel.com>
To: Robin Holt <holt@sgi.com>
CC: Petr Tesarik <ptesarik@suse.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Mon, 3 Nov 2008 13:47:58 -0800
Subject: RE: [PATCH V2 0/2] enable irqs when waiting for rwlocks
Thread-Topic: [PATCH V2 0/2] enable irqs when waiting for rwlocks
Thread-Index: Ack9qeCyuNA5uz6aRHefuDsw1fpU2QAU4xPw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35BE0554D@orsmsx505.amr.corp.intel.com>
References: <1224777451.11530.52.camel@elijah.suse.cz>
 <1225443142.6825.4.camel@elijah.suse.cz>
 <57C9024A16AD2D4C97DC78E552063EA35A7ED9D3@orsmsx505.amr.corp.intel.com>
 <20081103114638.GD8483@sgi.com>
In-Reply-To: <20081103114638.GD8483@sgi.com>
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

> Just a few years of experiencal evidence.  The equivalent of this patch
> has been in the SuSE SLES10 kernel for years and not been detected as
> being negative.

That's good to know.

Petr: I tried to apply these ... but the patches seem corrupted
(leading spaces dropped? ... I checked in the marc.info archive
and they seem broken there too).  Can you regenerate them and
repost (attachments are ok).

-Tony
