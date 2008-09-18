Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYIRSjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYIRSjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbYIRSjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:39:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60672 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbYIRSjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:39:45 -0400
Message-ID: <48D2A045.5000907@zytor.com>
Date: Thu, 18 Sep 2008 11:39:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v6
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <20080917015543.27172da4.akpm@linux-foundation.org> <20080917092732.GB32107@elte.hu> <20080917184618.GB6486@redhat.com> <48D159A7.5080907@zytor.com> <20080918105728.GF20967@elte.hu> <48D2758B.1000004@zytor.com> <20080918155041.GB3097@redhat.com> <48D27A7E.8090403@zytor.com> <20080918161957.GC3097@redhat.com>
In-Reply-To: <20080918161957.GC3097@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> 
> in my testing there was no significant difference between pre-filtering
> vs. not built in. However, there was a measureable affect of having them
> built in vs. not built in.
> 

<somewhat irrelevant rant>

Okay, I'm so bloody sick of hearing people justifying bloat by saying 
"no measurable difference."  That only means that you don't have GROSS 
bloat.  Unless you have real statistics to the contrary, most people's 
performance testing is at the very best accurate to 5-10%.  This is 
hardly "no bloat".

</somewhat irrelevant rant>

	-hpa
