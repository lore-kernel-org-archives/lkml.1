Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYHSBDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYHSBDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYHSBCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:02:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:24561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbYHSBCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:02:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,231,1217833200"; 
   d="scan'208";a="430254085"
Subject: Re: tbench regression on each kernel release from 2.6.22 -> 2.6.28
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48A98228.9090006@linux-foundation.org>
References: <48A086B6.2000901@linux-foundation.org>
	 <20080811.141501.01468546.davem@davemloft.net>
	 <Pine.LNX.4.64.0808121058550.4551@wrl-59.cs.helsinki.fi>
	 <1219025114.25933.6.camel@ymzhang>  <48A98228.9090006@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 09:01:46 +0800
Message-Id: <1219107706.8781.6.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-08-18 at 09:07 -0500, Christoph Lameter wrote:
> Zhang, Yanmin wrote:
> 
> > Other regressions on other machines are similar.
> 
> There are AIM7 regressions that are similar to tbench.
> 
> 2.6.22	28436
> 2.6.26	23064

Mostly, AIM7 has about 4~5% regression on my machines. As AIM7 result is stable,
so 4% is big. 

