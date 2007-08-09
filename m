Return-Path: <linux-kernel-owner+w=401wt.eu-S938680AbXHIFj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938680AbXHIFj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbXHIFjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:39:52 -0400
Received: from gw.goop.org ([64.81.55.164]:56689 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678AbXHIFjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:39:51 -0400
Message-ID: <46BAA840.2040403@goop.org>
Date: Wed, 08 Aug 2007 22:38:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       chrisw@sous-sol.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
References: <11865467522495-git-send-email-gcosta@redhat.com>	 <5d6222a80708080749t35c5c0ceo8b3b8f0cce50c666@mail.gmail.com>	 <1186615137.17470.100.camel@localhost.localdomain>	 <200708090224.16328.ak@suse.de> <1186620295.17752.23.camel@localhost.localdomain>
In-Reply-To: <1186620295.17752.23.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thu, 2007-08-09 at 02:24 +0200, Andi Kleen wrote:
>   
>> Not sure what's best. Ok using a normal export is easiest and not
>> that big an issue.
>>     
>
> Yeah, there's also been talk of breaking up paravirt_ops into multiple
> structs by area, which would lead naturally into finer-grained export
> control.

Yeah, I should dust that patch off again.

    J

