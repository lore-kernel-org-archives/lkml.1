Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYDGKE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYDGKE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 06:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbYDGKEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 06:04:49 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2651 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYDGKEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 06:04:49 -0400
Date: Mon, 7 Apr 2008 12:02:54 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: john stultz <johnstul@us.ibm.com>, Paul Mackerras <paulus@samba.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Close small window for vsyscall time inconsistencies
In-Reply-To: <alpine.LFD.1.10.0804070826390.3224@apollo.tec.linutronix.de>
Message-ID: <Pine.LNX.4.64.0804071159150.3750@localhost.localdomain>
References: <1207340264.6222.17.camel@localhost.localdomain>
 <200804070255.22516.zippel@linux-m68k.org> <alpine.LFD.1.10.0804070826390.3224@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 7 Apr 2008, Thomas Gleixner wrote:

> > So instead of shooting in the dark, I'd suggest to collect some
> >  numbers first,
> 
> That's what we did and John's analysis of the problem is pretty
> correct.

How about sharing this information?
I'm not saying that his analysis is incorrect, I just suspect it's 
incomplete, so I would simply like to see a little more information.
Is that too much to ask?

bye, Roman
