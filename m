Return-Path: <linux-kernel-owner+w=401wt.eu-S938348AbXHPDji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938348AbXHPDji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 23:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935326AbXHPDj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 23:39:27 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:30638 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbXHPDjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 23:39:25 -0400
X-IronPort-AV: i="4.19,268,1183359600"; 
   d="scan'208"; a="200859921:sNHT40240008"
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, rolandd@cisco.com
Subject: Re: drivers/infiniband/mlx/mad.c misplaced ;
X-Message-Flag: Warning: May contain useful information
References: <20070815235825.GB17004@redhat.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 15 Aug 2007 20:39:24 -0700
In-Reply-To: <20070815235825.GB17004@redhat.com> (Dave Jones's message of "Wed, 15 Aug 2007 19:58:25 -0400")
Message-ID: <adair7g2ln7.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Aug 2007 03:39:24.0732 (UTC) FILETIME=[0A3FEFC0:01C7DFB7]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!  Seems like checking for this is in the air, I just applied an
identical patch from Ilpo Järvinen.
