Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbYIPQpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbYIPQpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYIPQpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:45:41 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:23492 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYIPQpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:45:41 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, of-ewg <ewg@lists.openfabrics.org>,
       of-general <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: Re: [PATCH] ib/ehca: add flush CQE generation
References: <20080910162356.7294fe87@BL3D1974.boeblingen.de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 16 Sep 2008 09:45:38 -0700
In-Reply-To: <20080910162356.7294fe87@BL3D1974.boeblingen.de.ibm.com>
	(Alexander Schmidt's message of "Wed, 10 Sep 2008 16:23:56 +0200")
Message-ID: <adak5dcdop9.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Sep 2008 16:45:38.0799 (UTC) FILETIME=[A62E0FF0:01C9181B]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, queued for 2.6.28.
