Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbXITRWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbXITRWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbXITRT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:19:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:50710 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758498AbXITRTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:19:25 -0400
Date: Thu, 20 Sep 2007 19:19:23 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, discuss@x86-64.org
Subject: Re: [patch 3/7] Use extended crashkernel command line on x86_64
Message-ID: <20070920171923.GA19820@suse.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, discuss@x86-64.org
References: <20070913161428.343951643@strauss.suse.de> <20070913161429.387888398@strauss.suse.de> <20070919153329.cfe714e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919153329.cfe714e3.akpm@linux-foundation.org>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2007-09-20 00:33]:
> 
> Could you fix all that up please?

Thanks for the comments -- should be fixed now, see the new patch
series.


Thanks,
   Bernhard
