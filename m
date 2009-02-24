Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbZBXR7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbZBXR7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbZBXR7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:59:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:49844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbZBXR7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:59:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lQPVfSbY3bHHz2676O6N8c8nvUkt2g7k3UVaxaXeVlK0hksJUlFQNctwO29Us35W2O
         5URoVN0cF+KdzYDAb8KVALqxyTkvQb5BtShJeuCBKPE0rm5HSmwGPAnZE3uZEr/8A6f+
         ZZx9Scgtzbka9HBsv55wSTC64xae4t9IVIUug=
Date: Tue, 24 Feb 2009 18:58:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: What made this bug report better?
Message-ID: <20090224175854.GH5765@nowhere>
References: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain> <200902171007.28257.rusty@rustcorp.com.au> <20090220102705.GA2884@silver.sucs.org> <200902241343.22762.rusty@rustcorp.com.au> <20090224081612.GA6160@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224081612.GA6160@silver.sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 08:16:12AM +0000, Sitsofe Wheeler wrote:
> On Tue, Feb 24, 2009 at 01:43:22PM +1030, Rusty Russell wrote:
> > On Friday 20 February 2009 20:57:05 Sitsofe Wheeler wrote:
> > > What happened this time that made things succesful? Was the original
> > > mail too big? Did it not make it to the list?
> > 
> > Frederic was the difference; he pulled me in by CC'ing me, once he figured
> > out it was my bug.
> 
> Rusty, Ingo: Thanks for letting me know!
> 
> Frederic: What information are you looking for in bug reports? 


Like everyone, the most possible matching traces, locking states, and other
states (irq, atomic, ...), well it depends on the particular case.

The best thing is to provide a way to reproduce it, that's what you did, so
that we can use specific tracers for specific issues.


> What sort of areas interest you?

You mean, what I'm interested in the kernel?
All the kernel :-)
Though I have a preference for the kernel core, and improving tracing
because I'm lazy and I like when there are tools which do most of the things
for me.
 
> -- 
> Sitsofe | http://sucs.org/~sits/

