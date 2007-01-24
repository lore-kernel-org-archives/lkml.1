Return-Path: <linux-kernel-owner+w=401wt.eu-S932941AbXAXA4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbXAXA4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933156AbXAXA4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:56:18 -0500
Received: from secure.tummy.com ([66.35.36.132]:56961 "EHLO secure.tummy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbXAXA4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:56:18 -0500
Date: Tue, 23 Jan 2007 17:50:29 -0700
From: Sean Reifschneider <jafo@tummy.com>
To: bert hubert <bert.hubert@netherlabs.nl>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: select() setting ERESTARTNOHAND (514).
Message-ID: <20070124005029.GW28989@tummy.com>
References: <20070110234238.GB10791@tummy.com> <20070110.162747.28789587.davem@davemloft.net> <20070111010429.GN7121@tummy.com> <20070110.171520.23015257.davem@davemloft.net> <20070111082516.GU7121@tummy.com> <20070111222246.GA27976@outpost.ds9a.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070111222246.GA27976@outpost.ds9a.nl>
User-Agent: Mutt/1.4.2.2i
X-Hashcash: 1:26:070124:linux-kernel@vger.kernel.org::Uz9jKP+0OMGJrWE2:000000000
	0000000000000000000000017NvT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 11, 2007 at 11:22:46PM +0100, bert hubert wrote:
>Anything else relevant? Do you know which signal interrupted select? Is this
>a single or multithreaded application? And where did the signal come from?

It is, AFAIK, a multi-threaded application.  I don't have any information
on which signal interrupted the process.  I'll ask the person who reported
it to me, Doug, to respond with additional information.

>I tried to reproduce your problem in various ways on 2.6.20-rc4, but it
>didn't appear.

Thanks.

Sean
-- 
 [...] Premature optimization is the root of all evil.
                 -- Donald Knuth
Sean Reifschneider, Member of Technical Staff <jafo@tummy.com>
tummy.com, ltd. - Linux Consulting since 1995: Ask me about High Availability

