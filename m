Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbZISRHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbZISRHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZISRHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:07:37 -0400
Received: from mga10.intel.com ([192.55.52.92]:41324 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750924AbZISRHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:07:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,416,1249282800"; 
   d="scan'208";a="728409160"
Date: Sat, 19 Sep 2009 20:45:37 -0400
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Youquan,Song" <youquan.song@linux.intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Song, Youquan" <youquan.song@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gorcunov@gmail.com" <gorcunov@gmail.com>
Subject: Re: [PATCH] IR: Fix kernel hang if interrupt remapping disable in BIOS
Message-ID: <20090920004537.GC21419@youquan-linux.bj.intel.com>
References: <20090909160538.GA3799@youquan-linux.bj.intel.com> <1252532288.2767.27.camel@sbs-t61.sc.intel.com> <20090920002951.GA21419@youquan-linux.bj.intel.com> <1253379550.6317.13.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253379550.6317.13.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 09:59:10AM -0700, David Woodhouse wrote:
> On Sat, 2009-09-19 at 20:29 -0400, Youquan,Song wrote:
> > 
> > David,  Can you please pick this up? We want the bug fixed at 2.6.32.
> > Thanks.
> 
> It's in my tree and in linux-next; will go to Linus shortly. I'm just
> doing some final testing -- and having just merged the integer overflow
> fixes that Ben pointed out, I think I may leave it another day or so
> before I ask Linus to pull.

Fine. thanks. sorry for the noise.
 
