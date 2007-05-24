Return-Path: <linux-kernel-owner+w=401wt.eu-S1751282AbXEXRkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbXEXRkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbXEXRkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:40:43 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:41782 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbXEXRkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:40:42 -0400
X-IronPort-AV: i="4.14,574,1170662400"; 
   d="scan'208"; a="2432935:sNHT263827440"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Refactor "maybe missed event" code
X-Message-Flag: Warning: May contain useful information
References: <200705241651.05860.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 24 May 2007 10:40:39 -0700
In-Reply-To: <200705241651.05860.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 24 May 2007 16:51:05 +0200")
Message-ID: <adalkfe6rxk.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 May 2007 17:40:39.0876 (UTC) FILETIME=[A514B040:01C79E2A]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't fixing anything is it?  I think it's 2.6.23 material;
correct me if I'm wrong.

 - R.
