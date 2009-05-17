Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZEQJaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZEQJaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 05:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbZEQJaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 05:30:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:48444 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625AbZEQJaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 05:30:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,207,1241420400"; 
   d="scan'208";a="143694537"
Date: Sun, 17 May 2009 17:30:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unresponsiveness on linux desktop during file copy
Message-ID: <20090517093004.GA2635@localhost>
References: <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com> <alpine.DEB.1.10.0905151533070.13433@qirst.com> <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com> <4A0EFA08.4060106@redhat.com> <20090517011906.GA6375@localhost> <93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com> <20090517020829.GB6809@localhost> <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com> <20090517045800.GA32723@localhost> <93655eb70905162318oeccafa9p76b5594f9625aefc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93655eb70905162318oeccafa9p76b5594f9625aefc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 02:18:01PM +0800, Satish Eerpini wrote:
> > The numbers listed in your email? No the most relevant numbers are
> > memory and disk ones.
> 
> the numbers I earlier mentioned were the output of : "sar"
> for the number of mapped pages stays almost constant on my lappy too :
> Mapped:            70840 kB
> Mapped:            70860 kB
> Mapped:            70736 kB
> Mapped:            70860 kB

Hmm, how do you define/feel the unresponsiveness?  Is it related to
the currently *running* applications, or opening a *new* application?

Thanks,
Fengguang

