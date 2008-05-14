Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYENQgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYENQgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYENQge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:36:34 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:32757 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYENQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:36:33 -0400
X-IronPort-AV: E=Sophos;i="4.27,487,1204531200"; 
   d="scan'208";a="98664023"
From: Roland Dreier <rdreier@cisco.com>
To: "Faisal Latif" <flatif@NetEffect.com>
Cc: "Christophe Jaillet" <christophe.jaillet@wanadoo.fr>,
       "linux" <linux-kernel@vger.kernel.org>,
       "Nishi Gupta" <ngupta@NetEffect.com>,
       "Glenn Streiff" <gstreiff@NetEffect.com>,
       <general@lists.openfabrics.org>
Subject: Re: [ofa-general] RE: [PATCH 1/1] infiniband/hw/nes/: avoid unnecessary memset
References: <20080512213601.626C91C0008F@mwinf2103.orange.fr>
	<5E701717F2B2ED4EA60F87C8AA57B7CC080BD82B@venom2>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 14 May 2008 09:36:30 -0700
In-Reply-To: <5E701717F2B2ED4EA60F87C8AA57B7CC080BD82B@venom2> (Faisal Latif's
	message of "Tue, 13 May 2008 16:46:47 -0500")
Message-ID: <adatzh0j10x.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 May 2008 16:36:30.0647 (UTC) FILETIME=[A9D1F470:01C8B5E0]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks guys, applied for 2.6.27
