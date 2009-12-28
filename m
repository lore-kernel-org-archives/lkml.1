Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbZL1QKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbZL1QKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZL1QKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:10:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:39140 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZL1QKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:10:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,463,1257148800"; 
   d="scan'208";a="479637269"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "stable@kernel.org" <stable@kernel.org>, Simon Horman <horms@verge.net.au>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 28 Dec 2009 16:09:44 +0000
Subject: RE: [PATCH 3/3] ioat2,3: put channel hardware in known state at init
Thread-Topic: [PATCH 3/3] ioat2,3: put channel hardware in known state at
 init
Thread-Index: AcqDZrAboUp1uzDhSGyWTFM4apTg4AEcWk/Q
Message-ID: <129600E5E5FB004392DDC3FB599660D7CB3710BC@irsmsx504.ger.corp.intel.com>
References: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
 <20091223002606.32335.87363.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20091223002606.32335.87363.stgit@dwillia2-linux.ch.intel.com>
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
> Put the ioat2 and ioat3 state machines in the halted state with all
> errors cleared.
> 
> The ioat1 init path is not disturbed for stability, there are no
> reported ioat1 initiaization issues.
> 
> Cc: <stable@kernel.org>
> Reported-by: Roland Dreier <rdreier@cisco.com>
> Tested-by: Roland Dreier <rdreier@cisco.com>
> Acked-by: Simon Horman <horms@verge.net.au>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
