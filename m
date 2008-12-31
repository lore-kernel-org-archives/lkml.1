Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYLaQgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYLaQgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbYLaQgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:36:37 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:49983 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbYLaQgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:36:36 -0500
X-IronPort-AV: E=Sophos;i="4.36,308,1228089600"; 
   d="scan'208";a="222058919"
From: Roland Dreier <rdreier@cisco.com>
To: Or Gerlitz <ogerlitz@voltaire.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.29
References: <aday6y7x2yr.fsf@cisco.com> <495B66AE.1050706@voltaire.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 31 Dec 2008 08:36:33 -0800
In-Reply-To: <495B66AE.1050706@voltaire.com> (Or Gerlitz's message of "Wed, 31
	Dec 2008 14:33:50 +0200")
Message-ID: <adaabacqp2m.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Dec 2008 16:36:33.0706 (UTC) FILETIME=[F110F8A0:01C96B65]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > What about Jack's raw QP support/fixes patch set which he reposted on
 > December 15th?

didn't make this window.  How are you using raw QPs?
