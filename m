Return-Path: <linux-kernel-owner+w=401wt.eu-S966689AbXEVSws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966689AbXEVSws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760120AbXEVSwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:52:40 -0400
Received: from www.osadl.org ([213.239.205.134]:39296 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757924AbXEVSwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:52:39 -0400
Subject: Re: [PATCH] powerpc 2.6.21-rt6: revert spider_net
From: Thomas Gleixner <tglx@linutronix.de>
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20070522184632.GL5921@austin.ibm.com>
References: <yyi646l6pmr.wl@toshiba.co.jp>
	 <20070522184632.GL5921@austin.ibm.com>
Content-Type: text/plain
Date: Tue, 22 May 2007 20:52:34 +0200
Message-Id: <1179859954.12708.130.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 13:46 -0500, Linas Vepstas wrote:
> On Tue, May 22, 2007 at 08:53:32PM +0900, Tsutomu OWA wrote:
> > 
> > Hi Ingo and Thomas,
> >
> > To revert spider_net.c to original one as it turns out that the patch 
> 
> As the spidernet maintainer, I had not forwarded the previous patch
> upstream; it should not have been applied.

Linas,

that's against preempt-rt, where we picked up owa-sans patch.

Thanks,

	tglx


