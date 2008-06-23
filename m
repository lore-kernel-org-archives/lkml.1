Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbYFWUXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbYFWUXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762173AbYFWUX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:23:27 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:37913 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762167AbYFWUXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:23:24 -0400
X-IronPort-AV: E=Sophos;i="4.27,692,1204531200"; 
   d="scan'208";a="59529897"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, general@lists.openfabrics.org,
       fenkes@de.ibm.com, raisch@de.ibm.com, hnguyen@de.ibm.com
Subject: Re: [PATCH REPOST #2] IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts
References: <200806131655.43410.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 23 Jun 2008 13:23:23 -0700
In-Reply-To: <200806131655.43410.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Fri, 13 Jun 2008 16:55:41 +0200")
Message-ID: <adaprq73npg.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jun 2008 20:23:23.0480 (UTC) FILETIME=[FC396D80:01C8D56E]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok, I queued this for 2.6.27.  thanks everyone
