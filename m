Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbZGHW0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbZGHW0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZGHW0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:26:15 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:49489 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbZGHW0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:26:15 -0400
X-IronPort-AV: E=Sophos;i="4.42,370,1243814400"; 
   d="scan'208";a="340194362"
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, of-ewg <ewg@lists.openfabrics.org>,
       of-general <general@lists.openfabrics.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: Re: [PATCH] ehca: use port autodetect mode as default
References: <20090707160639.6b45bf4d@BL3D1974.boeblingen.de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 08 Jul 2009 15:26:13 -0700
In-Reply-To: <20090707160639.6b45bf4d@BL3D1974.boeblingen.de.ibm.com>
	(Alexander Schmidt's message of "Tue, 7 Jul 2009 16:06:39 +0200")
Message-ID: <adamy7e24my.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jul 2009 22:26:14.0241 (UTC) FILETIME=[1A834D10:01CA001B]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks good, applied
