Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbYJ1SWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbYJ1SWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYJ1SWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:22:35 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:18527 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYJ1SWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wPZKhAWhoeHx2FEidq4lOeEMVMPcYA9u6qNMTX+8ic2TCy/hU2vEWjee8iNQr3h1iR
         /zTahNrNCUFx6xpt3buVf71AQqB8eQW8VJ6lban9LZqnJ00AJ1kfljqTuymSfgRzimYx
         nUsyY77m/u8xT1qcFt4wBJuiOZzxZ74SOtS6w=
Date: Tue, 28 Oct 2008 21:22:26 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix init_memory_mapping for [dc000000 - e0000000)
Message-ID: <20081028182226.GD7357@localhost>
References: <490406FD.30604@kernel.org> <20081027165028.GB30573@linux-os.sc.intel.com> <20081027175547.GE3046@elte.hu> <49067058.7010106@kernel.org> <20081028092737.GT15734@elte.hu> <20081028174813.GB7357@localhost> <20081028181004.GA11275@elte.hu> <20081028181459.GC7357@localhost> <20081028181800.GC11275@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028181800.GC11275@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Oct 28, 2008 at 07:18:00PM +0100]
...
| > 
| > Ingo, I think it's a subject for SubmittingPatches then. To 
| > eliminate future possible questions for those who never saw it 
| > before. Thanks for explanation!
| 
| well, this isnt an official policy in any way and we dont want to 
| burden/complicate the life of other maintainers by putting it into 
| linux/Documentation/SubmittingPatches. We are still experimenting with 
| this concept - and while the results are very encouraging, YMMV!
| 
| 	Ingo
| 

Got it, thanks!

		- Cyrill -
