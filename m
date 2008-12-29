Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYL2WNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYL2WNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 17:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYL2WNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 17:13:09 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:52445 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYL2WNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 17:13:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aDz//kf1RmozjgWXpMKSNi26Y2GrrIWw6ldPMizehjLTpvZ1w6/cRSA3VAUJBwFysz
         4JtptyBWoETw4GnF9TUvKe/k11Qs9YncGKqQzzOW7TFZMPX/HjwwFk3cJwNXy8BrItyu
         H0SjbEsVBYO2bqIBH1WRcg962LnjFU7a0kucU=
Date: Mon, 29 Dec 2008 23:13:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081229221301.GD5829@nowhere>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081229220937.GC5829@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229220937.GC5829@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 11:09:37PM +0100, Frederic Weisbecker wrote:
> Pekka, note that I would be pleased to add statistical tracing on
> this tracer, but I would need a hashtable, or an array, or a list, or whatever
> iterable to insert the data into the stat tracing api.
> 
> But I don't know your projects about this... whether you wanted to use a section
> or something else...

Hmm, forgot to cc Ingo...

