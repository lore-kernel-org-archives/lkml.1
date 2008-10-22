Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbYJVWzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbYJVWzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYJVWy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:54:56 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:43477 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYJVWyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:54:55 -0400
X-IronPort-AV: E=Sophos;i="4.33,467,1220227200"; 
   d="scan'208";a="94825908"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, general@lists.openfabrics.org,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, hnguyen@de.ibm.com
Subject: Re: [PATCH]IB/ehca:reject dynamic memory add/remove
References: <200810131310.34413.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 22 Oct 2008 15:54:53 -0700
In-Reply-To: <200810131310.34413.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Mon, 13 Oct 2008 13:10:32 +0200")
Message-ID: <adaskqoutoi.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Oct 2008 22:54:53.0951 (UTC) FILETIME=[328CF8F0:01C93499]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied with a slightly expanded changelog.
