Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZJCMAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZJCMAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 08:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZJCMAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 08:00:46 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:46065 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZJCMAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 08:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y6XkQtp2vt2vtpP4F/H55CdTJrIsljnkmaTkQNpCfags1M1CFaUzaQzAmrE94Gz/tC
         t92VCkZhfSPbBI89x4nubLz62jQ3jJWqRf0gTJTSda+LaFoSZqWk9II9nGXBRV+DmmF3
         OMaaChl5cqf3o0OcaypRaey7i6xzjd+QiyNg4=
Date: Sat, 3 Oct 2009 14:00:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: ftrace WARNING during boot
Message-ID: <20091003120046.GC6366@nowhere>
References: <20091003105318.GB32486@mea-ext.zmailer.org> <20091003110002.GA6162@nowhere> <20091003112850.GC32486@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003112850.GC32486@mea-ext.zmailer.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 02:28:50PM +0300, Matti Aarnio wrote:
> On Sat, Oct 03, 2009 at 01:00:03PM +0200, Frederic Weisbecker wrote:
> > On Sat, Oct 03, 2009 at 01:53:18PM +0300, Matti Aarnio wrote:
> > > This is perhaps already fixed, as I have two a bit newer kernels than this one,
> > > but reporting is better than being silent..
> > 
> > 
> > Hi,
> > 
> > Which kernel is this? Does it happen in the current 2.6.32-rc1 ?
> 
> I do know that reading the trace is difficult, but the asked for information
> is down in there.  Intentionally put there by the kernel-oops coders, I presume.


Ah ok. It's just that I'm not that familiar with fedora's kernels naming :-)

 
> I do use vendor kernels, and Fedora 12 beta program has not yet made
> 2.6.32-rc1 kernel available.
> 
> However this does not appear in 2.6.31.1-56.fc12.x86_64 kernel that is lattest
> from vendor, but there I have some other troubles why I took a bit older kernel.
> (Other troubles with the xfs filesystem lock handling.)



So this looks based on a 2.6.31.1 kernel, more stable. And if it doesn't
happen with it, then it's fine.

That said, it's all about fedora based kernel so it's a bit hard to tell
if it came from fedora adds or vanilla kernel code.

I personnally can't help about Fedora kernels related problems.

Thanks.

