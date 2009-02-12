Return-Path: <linux-kernel-owner+w=401wt.eu-S1761726AbZBLXoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761726AbZBLXoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZBLXoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:44:46 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:61639 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZBLXoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:44:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r84CDn1n2SWXL0eo/vfLkOvhXURx5aW0YTOKJXrXexkgv/P8+rzfC+2kr5YmHy908m
         N8vq4kFAK1mgSnvgE3DlBh8F9/+2MP5KT6WyXOfawgf/IcwJgoTitKim79gwpscE1zoZ
         mrVYJsfLXCagaiWCoBI44K0dtTXp84IsaSgIM=
Date: Thu, 12 Feb 2009 18:44:34 -0500
From: Josh Boyer <jwboyer@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7][RFC] function graph tracer port to PowerPC
Message-ID: <20090212234434.GC2385@yoda.jdub.homelinux.org>
References: <20090212011051.265346435@goodmis.org> <4994B1A3.8080502@am.sony.com> <alpine.DEB.1.10.0902121840590.15469@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902121840590.15469@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 06:41:26PM -0500, Steven Rostedt wrote:
>
>On Thu, 12 Feb 2009, Geoff Levand wrote:
>
>> On 02/11/2009 05:10 PM, Steven Rostedt wrote:
>> > This is the port to PowerPC of the function graph tracer that was written
>> > by Frederic Weisbecker for the x86 architecture.  It is broken up
>> > into a series of logical steps.
>> 
>> I added these to my ps3-linux.git tree.  Very casual testing shows
>> they seem to work OK.
>> 
>> 
>> Tested-by: Geoff Levand <geoffrey.levand@am.sony.com>  Working OK on PS3.
>
>Thanks!
>
>Is the ps3 64 or 32 bit? I'll put your tested by on the appropriate 
>patches.

64-bit.

josh
