Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbYLWPd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbYLWPd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 10:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYLWPdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 10:33:19 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:26400 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYLWPdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 10:33:18 -0500
X-IronPort-AV: E=Sophos;i="4.36,271,1228089600"; 
   d="scan'208";a="121992275"
From: Roland Dreier <rdreier@cisco.com>
To: "Ron Livne" <ronli.voltaire@gmail.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.29
References: <aday6y7x2yr.fsf@cisco.com>
	<3b5e77ad0812222354y5d4effe8xc6750d6620e20c75@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 23 Dec 2008 07:33:06 -0800
In-Reply-To: <3b5e77ad0812222354y5d4effe8xc6750d6620e20c75@mail.gmail.com>
	(Ron Livne's message of "Tue, 23 Dec 2008 09:54:44 +0200")
Message-ID: <adaocz2x5xp.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Dec 2008 15:33:06.0476 (UTC) FILETIME=[C079C6C0:01C96513]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Any chance create_qp_flags will get in?

 Nope, since that's stuck behind XRC.
