Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbXFKTpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbXFKTpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbXFKTp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:45:28 -0400
Received: from www.osadl.org ([213.239.205.134]:42813 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752507AbXFKTp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:45:27 -0400
Subject: Re: 2.6.21-rt2..8 troubles
From: Thomas Gleixner <tglx@linutronix.de>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <466DA42A.6010600@rncbc.org>
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org>
	 <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu>
	 <46574DE4.2080900@rncbc.org> <1180195709.4264.7.camel@chaos>
	 <4658A4F4.1080204@rncbc.org>  <46660369.2070104@rncbc.org>
	 <1181317625.4404.332.camel@chaos>
	 <59605.213.13.107.141.1181326897.squirrel@www.rncbc.org>
	 <1181328636.4404.335.camel@chaos>  <466DA42A.6010600@rncbc.org>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 21:45:22 +0200
Message-Id: <1181591122.8176.159.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-11 at 20:36 +0100, Rui Nuno Capela wrote:
> > I'm spinning -rt10 with a couple of fixes. Should be out sometimes
> > tomorrow. If the problem persists, we need to dig deeper.
> > 
> 
> Uhoh. I'm sorry to tell, but the problem is still creeping on
> 2.6.21.4-rt11 and -rt12 :(
> 
> So sorry.

Hmm. Does it happen, when you boot with maxcpus=1 on the kernel
commandline ?

	tglx


