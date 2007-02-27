Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXB0WrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXB0WrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 17:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXB0WrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 17:47:24 -0500
Received: from outmail1.freedom2surf.net ([194.106.33.237]:48121 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXB0WrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 17:47:24 -0500
Message-ID: <45E4B33D.8080705@f2s.com>
Date: Tue, 27 Feb 2007 22:39:57 +0000
From: Ian Molton <spyro@f2s.com>
Organization: The Dragon Roost
User-Agent: Thunderbird 2.0a1 (X11/20061107)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ian Molton <spyro@f2s.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udivdi3: 64 bit divide
References: <20070226173517.66bf0fec@freekitty> <20070227122437.da27c3cd.akpm@linux-foundation.org> <20070227131840.672d6932@localhost> <20070227133656.c452fbb4.akpm@linux-foundation.org> <20070227222430.GC10380@flint.arm.linux.org.uk>
In-Reply-To: <20070227222430.GC10380@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Tue, Feb 27, 2007 at 01:36:56PM -0800, Andrew Morton wrote:
>> On Tue, 27 Feb 2007 13:18:40 -0800 Stephen Hemminger <shemminger@linux-foundation.org> wrote:
>>> Then we should pull the existing udivdi3 implementations?
>> Not much point really.  Some architectures have gone and done that, but x86
>> has not.  x86 has enough coverage for us to pick up most problems, and any
>> remaining problems are obviously in scruffy architectures which don't care
>> about performance ;)
> 
> I doubt arm26 uses udivdi3, but that's something Ian would have to
> confirm.

I doubt it is used also, however I am not in a position to test this 
until at least after I have moved house. Please leave alone for now.

