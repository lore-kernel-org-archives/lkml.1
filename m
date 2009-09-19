Return-Path: <linux-kernel-owner+w=401wt.eu-S1751373AbZISQ73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbZISQ73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 12:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZISQ72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 12:59:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46728 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZISQ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 12:59:28 -0400
Subject: Re: [PATCH] IR: Fix kernel hang if interrupt remapping disable in
 BIOS
From: David Woodhouse <dwmw2@infradead.org>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "Song, Youquan" <youquan.song@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gorcunov@gmail.com" <gorcunov@gmail.com>
In-Reply-To: <20090920002951.GA21419@youquan-linux.bj.intel.com>
References: <20090909160538.GA3799@youquan-linux.bj.intel.com>
	 <1252532288.2767.27.camel@sbs-t61.sc.intel.com>
	 <20090920002951.GA21419@youquan-linux.bj.intel.com>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 09:59:10 -0700
Message-Id: <1253379550.6317.13.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 20:29 -0400, Youquan,Song wrote:
> 
> David,  Can you please pick this up? We want the bug fixed at 2.6.32.
> Thanks.

It's in my tree and in linux-next; will go to Linus shortly. I'm just
doing some final testing -- and having just merged the integer overflow
fixes that Ben pointed out, I think I may leave it another day or so
before I ask Linus to pull.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

