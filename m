Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbYCDRuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbYCDRuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYCDRt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:49:59 -0500
Received: from gw.goop.org ([64.81.55.164]:38672 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbYCDRt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:49:59 -0500
Message-ID: <47CD8A92.7080909@goop.org>
Date: Tue, 04 Mar 2008 09:44:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
 to 1MB
References: <20080224174605.GA21661@mailshack.com>	 <47C22568.1010405@zytor.com>	 <1203958478.20033.1239002461@webmail.messagingengine.com>	 <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>	 <20080228131341.GA25213@mailshack.com>	 <20080228132822.GA25278@mailshack.com>	 <1204233131.28798.12.camel@cthulhu.hellion.org.uk>	 <47C72432.3010606@zytor.com> <1204240609.28798.33.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1204240609.28798.33.camel@cthulhu.hellion.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> BTW Jeremy, the kernel doesn't use XENMEM_memory_map -- any reason other
> than it not being useful at the time? These days the tools can push an
> arbitrary e820 down for a guest which might be useful to support,
> although nothing interesting is done with it today.

No, never looked at that stuff in detail.  I'll bear it in mind.

    J
