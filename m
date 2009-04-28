Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbZD1OBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbZD1OBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760591AbZD1OBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:01:34 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:59722 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760248AbZD1OBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:01:32 -0400
X-IronPort-AV: E=Sophos;i="4.40,260,1238976000"; 
   d="scan'208";a="294359461"
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: Stefan Roscher <ossrosch@linux.vnet.ibm.com>, fenkes@de.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, OF-EWG <ewg@lists.openfabrics.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>, raisch@de.ibm.com,
       alexschm@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: [ewg] Re: [PATCH 1/3] IB/ehca: Replace vmalloc with kmalloc
References: <200904211716.45245.ossrosch@linux.vnet.ibm.com>
	<adaws9dvrkp.fsf@cisco.com>
	<200904221602.29028.ossrosch@linux.vnet.ibm.com>
	<20090428150736.1ea143f0@BL3D1974.boeblingen.de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 28 Apr 2009 07:01:32 -0700
In-Reply-To: <20090428150736.1ea143f0@BL3D1974.boeblingen.de.ibm.com>
	(Alexander Schmidt's message of "Tue, 28 Apr 2009 15:07:36 +0200")
Message-ID: <adabpqgx4g3.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2009 14:01:32.0192 (UTC) FILETIME=[D5AD1200:01C9C809]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > did you have a chance to take a look at the patchset and will you apply it, or
 > are there any outstanding issues we need to address?

I guess it's OK, but definitely 2.6.31 material.  I guess I'll stick it
linux-next soon.

 - R.
