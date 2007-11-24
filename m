Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbXKXVsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbXKXVsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 16:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbXKXVsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 16:48:15 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:33316 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXKXVsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 16:48:14 -0500
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Marcus Eder <meder@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Fix static rate regression
X-Message-Flag: Warning: May contain useful information
References: <200711221126.27465.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 24 Nov 2007 13:48:13 -0800
In-Reply-To: <200711221126.27465.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 22 Nov 2007 12:26:26 +0200")
Message-ID: <adabq9jtiw2.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Nov 2007 21:48:13.0411 (UTC) FILETIME=[B67C4330:01C82EE3]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
