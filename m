Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbYARW1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbYARW1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYARW1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:27:42 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:13837 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYARW1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:27:40 -0500
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 4/4] IB/ehca: Prevent RDMA-related connection failures
X-Message-Flag: Warning: May contain useful information
References: <200801171502.34287.fenkes@de.ibm.com>
	<200801171507.25145.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 18 Jan 2008 14:27:38 -0800
In-Reply-To: <200801171507.25145.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 17 Jan 2008 15:07:24 +0100")
Message-ID: <ada4pdawyzp.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jan 2008 22:27:39.0322 (UTC) FILETIME=[5565E1A0:01C85A21]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied 1-4.
