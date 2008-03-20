Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYCTTks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYCTTks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 15:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYCTTkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 15:40:39 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:10014 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYCTTki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 15:40:38 -0400
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Pavel Emelyanov <xemul@openvz.org>, raisch@de.ibm.com,
       general@lists.openfabrics.org,
       Hal Rosenstock <hal.rosenstock@gmail.com>, hnguyen@de.ibm.com
Subject: Re: [PATCH] ehca: remove tgid checking
X-Message-Flag: Warning: May contain useful information
References: <200803201756.52818.ossrosch@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 20 Mar 2008 12:40:34 -0700
In-Reply-To: <200803201756.52818.ossrosch@linux.vnet.ibm.com> (Stefan Roscher's message of "Thu, 20 Mar 2008 17:56:50 +0100")
Message-ID: <adawsnxxjyl.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Mar 2008 19:40:34.0791 (UTC) FILETIME=[43EC5770:01C88AC2]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for the quick patch, applied!
