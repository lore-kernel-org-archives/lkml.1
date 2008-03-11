Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYCKEQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYCKEQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYCKEQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:16:40 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:29247 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbYCKEQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:16:39 -0400
To: Erez Zilber <erezz@voltaire.com>
Cc: Arne Redlich <arne.redlich@xiranet.com>, Roland Dreier <rolandd@cisco.com>,
       ofa-general <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] IB/iSER: fix list iteration bug
X-Message-Flag: Warning: May contain useful information
References: <877igkxffl.fsf@confield.dd.xiranet.com>
	<47CD3B7A.2010106@voltaire.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 10 Mar 2008 21:16:11 -0700
In-Reply-To: <47CD3B7A.2010106@voltaire.com> (Erez Zilber's message of "Tue, 04 Mar 2008 14:07:22 +0200")
Message-ID: <adalk4pnbec.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Mar 2008 04:16:12.0112 (UTC) FILETIME=[A3DF6500:01C8832E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
