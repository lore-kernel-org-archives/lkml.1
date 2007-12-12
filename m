Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbXLLU0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbXLLU0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbXLLU0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:26:44 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:6450 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbXLLU0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:26:43 -0500
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Marcus Eder <meder@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Return correct #SGEs for SRQ
X-Message-Flag: Warning: May contain useful information
References: <200712101220.57876.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 12 Dec 2007 12:26:41 -0800
In-Reply-To: <200712101220.57876.fenkes@de.ibm.com> (Joachim Fenkes's message of "Mon, 10 Dec 2007 12:20:57 +0100")
Message-ID: <ada7ijj8xry.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Dec 2007 20:26:41.0407 (UTC) FILETIME=[4E0F30F0:01C83CFD]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
