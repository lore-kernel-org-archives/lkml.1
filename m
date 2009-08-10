Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZHJPd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZHJPd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZHJPd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:33:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbZHJPd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:33:28 -0400
Date: Mon, 10 Aug 2009 08:32:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "Tan, Wei Chong" <wei.chong.tan@intel.com>,
       John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
In-Reply-To: <20090810090506.GA9746@elte.hu>
Message-ID: <alpine.LFD.2.01.0908100831430.3288@localhost.localdomain>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <B28277FD4E0F9247A3D55704C440A140D5ADEC74@pgsmsx504.gar.corp.intel.com> <20090805080647.GC30307@elte.hu>
 <B28277FD4E0F9247A3D55704C440A140D5D683F3@pgsmsx504.gar.corp.intel.com> <20090810090506.GA9746@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Aug 2009, Ingo Molnar wrote:
> 
> Linus, can i have your SOB line please?

Sure, with the testing, feel free to add

	Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

thanks,

		Linus
