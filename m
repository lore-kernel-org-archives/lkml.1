Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbXB0RjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbXB0RjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 12:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXB0RjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 12:39:08 -0500
Received: from relay00.pair.com ([209.68.5.9]:1074 "HELO relay00.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751700AbXB0RjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 12:39:05 -0500
X-pair-Authenticated: 24.241.238.207
Message-ID: <45E46CB4.1080009@cybsft.com>
Date: Tue, 27 Feb 2007 11:39:00 -0600
From: "K.R. Foley" <kr@cybsft.com>
Organization: Cybersoft Solutions, Inc.
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.20-rt1, yum/rpm
References: <20070205065636.GA1652@elte.hu>
In-Reply-To: <20070205065636.GA1652@elte.hu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i have released the v2.6.20-rt1 kernel, which can be downloaded from the 
> usual place:
> 

I have a couple of questions regarding priorities of the softirqs, IRQ
handlers, etc.

With some exceptions, back in 2.6.18 and prior patches the IRQ threads
were prioritized between 50 and 25 and the most of the softirqs were
prioritized at 1? In newer patches it looks like they are all
prioritized at 50?

I was just curious what went into making these choices? I am just trying
to better understand these decisions.

Thanks,

-- 
   kr
