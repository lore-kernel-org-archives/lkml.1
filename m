Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbXCIVkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbXCIVkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbXCIVkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:40:51 -0500
Received: from gw.goop.org ([64.81.55.164]:54600 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbXCIVku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:40:50 -0500
Message-ID: <45F1D45F.4020000@goop.org>
Date: Fri, 09 Mar 2007 13:40:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zachary Amsden <zach@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309201257.GA5761@elte.hu> <Pine.LNX.4.64.0703091305090.10832@woody.linux-foundation.org> <20070309213607.GA16796@elte.hu>
In-Reply-To: <20070309213607.GA16796@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> but ... maybe because VMI is so lowlevel and covers /all/ of x86 today, 
> it will always be able to emulate whatever different concept we can come 
> up with? Do we really know this absolutely sure?
>   

Why don't you make a specific proposal, and we'll work out the details.

    J
