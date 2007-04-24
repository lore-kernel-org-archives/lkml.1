Return-Path: <linux-kernel-owner+w=401wt.eu-S1422908AbXDXRwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422908AbXDXRwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422927AbXDXRwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:52:37 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:23181 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422919AbXDXRwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:52:20 -0400
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="140050565:sNHT40708737"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>
Subject: Re: [PATCH] eHCA: Add "Modify Port" verb
X-Message-Flag: Warning: May contain useful information
References: <200704241744.31691.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 24 Apr 2007 10:52:18 -0700
In-Reply-To: <200704241744.31691.fenkes@de.ibm.com> (Joachim Fenkes's message of "Tue, 24 Apr 2007 17:44:31 +0200")
Message-ID: <adaabwx4q3x.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Apr 2007 17:52:18.0523 (UTC) FILETIME=[4D1D42B0:01C78699]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, applied for 2.6.22.
