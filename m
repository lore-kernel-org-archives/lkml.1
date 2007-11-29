Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbXK2Dm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbXK2Dm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 22:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbXK2Dmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 22:42:50 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:59833 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbXK2Dmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 22:42:49 -0500
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Marcus Eder <meder@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Fix static rate if path faster than link
X-Message-Flag: Warning: May contain useful information
References: <200711281446.29085.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 28 Nov 2007 19:42:43 -0800
In-Reply-To: <200711281446.29085.fenkes@de.ibm.com> (Joachim Fenkes's message of "Wed, 28 Nov 2007 15:46:28 +0200")
Message-ID: <adatzn5n2do.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Nov 2007 03:42:43.0598 (UTC) FILETIME=[E6283AE0:01C83239]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
