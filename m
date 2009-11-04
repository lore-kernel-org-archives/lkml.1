Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZKDRU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZKDRU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbZKDRU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:20:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:3515 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757336AbZKDRU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:20:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,681,1249282800"; 
   d="scan'208";a="743815854"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Brad Spengler <spender@grsecurity.net>
CC: Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Wed, 4 Nov 2009 09:20:13 -0800
Subject: RE: [PATCH] ia64: Don't call SAL < 3.2 for extended config space
Thread-Topic: [PATCH] ia64: Don't call SAL < 3.2 for extended config space
Thread-Index: Acpdcoj4rEqm2DIhQpqP87zcBU+ftQAAERiw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E36222B3@orsmsx505.amr.corp.intel.com>
References: <20091011074531.GA12357@grsecurity.net>
	<4AD1AE0D.1030007@kernel.org>	<4AD24766.7050205@kernel.org>
	<20091011213245.GC18513@grsecurity.net>
	<20091011231039.GB7545@parisc-linux.org>
	<20091012135628.GA310@grsecurity.net>
	<20091012142430.GE7545@parisc-linux.org>
	<20091013045808.GB9782@grsecurity.net>
 <20091104091608.7b813549@jbarnes-piketon>
In-Reply-To: <20091104091608.7b813549@jbarnes-piketon>
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

> I've dropped the ball on this one though; maybe Tony already picked it
> up?  Tony?

Yes.  It went in to Linus' tree with the git pull I sent on Monday (just
prior to -rc6).

Commit: adcd74034 ...

-Tony
