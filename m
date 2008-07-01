Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYGARz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYGARz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 13:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYGARzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 13:55:13 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:49100 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYGARzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 13:55:12 -0400
X-IronPort-AV: E=Sophos;i="4.27,732,1204531200"; 
   d="scan'208";a="61895767"
From: Roland Dreier <rdreier@cisco.com>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Make device table externally visible
References: <200806061835.43802.fenkes@de.ibm.com>
	<48499C11.7030504@gmail.com> <200807011614.19670.fenkes@de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 01 Jul 2008 10:55:09 -0700
In-Reply-To: <200807011614.19670.fenkes@de.ibm.com> (Joachim Fenkes's message
	of "Tue, 1 Jul 2008 16:14:19 +0200")
Message-ID: <adawsk5cww2.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2008 17:55:10.0113 (UTC) FILETIME=[9AAB5110:01C8DBA3]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
