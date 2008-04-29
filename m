Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbYD2SUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbYD2SUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbYD2SUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:20:32 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:12639 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083AbYD2SUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:20:30 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, Roland Dreier <rolandd@cisco.com>,
       hnguyen@de.ibm.com, raisch@de.ibm.com, fenkes@de.ibm.com
Subject: Re: [REPOST][PATCH] IB/ehca: Allocate event queue size depending on max number of CQs and QPs
References: <200804291744.17235.ossrosch@linux.vnet.ibm.com>
	<adafxt4y5kx.fsf@cisco.com>
	<200804292015.38321.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 29 Apr 2008 11:20:28 -0700
In-Reply-To: <200804292015.38321.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Tue, 29 Apr 2008 20:15:36 +0200")
Message-ID: <ada4p9kwmj7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Apr 2008 18:20:28.0770 (UTC) FILETIME=[B3D5BC20:01C8AA25]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, makes sense, applied.

fast turnaround too ;)
