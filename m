Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYGUKDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYGUKDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbYGUKC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:02:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:61094 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYGUKC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:02:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,222,1215414000"; 
   d="scan'208";a="22711044"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: iwlwifi: fix build bug in "iwlwifi: fix LED stall"
Date: Mon, 21 Jul 2008 13:02:31 +0300
Message-ID: <C07C4589BE74A34981C3C3525EE1F801042DD9DC@hasmsx412.ger.corp.intel.com>
In-Reply-To: <20080721083654.GA19849@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: iwlwifi: fix build bug in "iwlwifi: fix LED stall"
Thread-Index: AcjrDS+zQHLd26cmSuGKPtkGi12p9gAC41oQ
References: <20080720.104411.81744468.davem@davemloft.net> <20080721083654.GA19849@elte.hu>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "David Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
X-OriginalArrivalTime: 21 Jul 2008 10:02:38.0185 (UTC) FILETIME=[E7DD6D90:01C8EB18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Monday, July 21, 2008 11:37 AM
>To: David Miller
>Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Winkler,
Tomas;
>John W. Linville
>Subject: iwlwifi: fix build bug in "iwlwifi: fix LED stall"
>
>
>hi David,
>
>>       iwlwifi: fix LED stall
>
>please find a small build fix below.
>
There are already patches that fix this. John has to pick them up from
the mail.
Thanks
Tomas

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

