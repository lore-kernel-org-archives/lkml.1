Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYAHWze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYAHWze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYAHWzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:55:16 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:4011 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbYAHWzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HZC4xSt9pl/KVYHcgq0yxbmoz7PX3T1RwVVskX74ndjwpwHKbOnWCuiYNL/o55MyqpCg4n7LaqcUFjGmetf6u41yWUvg7eIVjuwhuWGBCU97FV8eMjoETGduSwXRbMRlpO1XSgrE370BvsMMA5j+ern5+HnTZTT2pfgSViobq3M=
Message-ID: <4783FF4D.90104@gmail.com>
Date: Tue, 08 Jan 2008 23:55:09 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 3/5] x86: coding style fixes in arch/x86/ia32/ia32_aout.c
References: <20080108203233.01bb5c7f@paolo-desktop> <20080108150439.6388028e@bree.surriel.com> <20080108215247.GE14829@elte.hu> <20080108221722.GA27698@uranus.ravnborg.org>
In-Reply-To: <20080108221722.GA27698@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2008 11:17 PM, Sam Ravnborg wrote:
>>> Most of these kernel changes would probably get in the way of real 
>>> development, making patches reject that would otherwise apply.
>> I'm curious, in what way would they interfere?
> 
> Developer A work one some complicated stuff in foo.c which is
> not yet -mm fooder.
> 
> Developer B submits and have applied a massive cleanup to some of the
> files touced by Developer A's patch.
> 
> Developer A now needs to fix up his stuff.

Ok, to be honest, how often is this a problem?

And then, how hard is it to rebase the patch?

And if it is a problem, then you can still drop a message, such as don't do 
this, I have a big patch here.
