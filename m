Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXJHOsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXJHOsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 10:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXJHOsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 10:48:45 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:52041 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXJHOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 10:48:44 -0400
X-IronPort-AV: E=Sophos;i="4.21,243,1188802800"; 
   d="scan'208";a="179691469"
To: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Updated InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
References: <adaodfdkv59.fsf@cisco.com>
	<200710080838.12778.jackm@dev.mellanox.co.il>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 08 Oct 2007 07:48:26 -0700
In-Reply-To: <200710080838.12778.jackm@dev.mellanox.co.il> (Jack Morgenstein's message of "Mon, 8 Oct 2007 08:38:12 +0200")
Message-ID: <adaabqtll1h.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Oct 2007 14:48:26.0398 (UTC) FILETIME=[4870D3E0:01C809BA]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > >  - XRC.  Given the length of the backlog above and the fact that a
 > >    first draft of this code has not been posted yet, I don't see any
 > >    way that we could have something this major ready in time.
 > > 
 > I posted the first draft patch set to the OpenFabrics list on September 18:

Sorry, I didn't update that text.  But my backlog is still too big to
get XRC into 2.6.24.

 - R.
