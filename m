Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbZAHQZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbZAHQZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbZAHQZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:25:36 -0500
Received: from adelie.canonical.com ([91.189.90.139]:45389 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZAHQZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:25:35 -0500
Date: Thu, 8 Jan 2009 16:25:32 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>, davej@redhat.com,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: scripts/checkpatch.pl : undefined value as an ARRAY reference
Message-ID: <20090108162532.GD28466@shadowen.org>
References: <3f9a31f40901070454x678f75d2xee2a6de04a940321@mail.gmail.com> <20090107130742.GD2520@shadowen.org> <3f9a31f40901070527y31fcccc9n5b3d52faa58e359e@mail.gmail.com> <20090107235037.GF12402@shadowen.org> <3f9a31f40901072040x4e1e3be9vece333b19a24a645@mail.gmail.com> <20090108145410.GG18120@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108145410.GG18120@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 03:54:10PM +0100, Ingo Molnar wrote:
> 
> * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
> 
> > On Thu, Jan 8, 2009 at 5:20 AM, Andy Whitcroft <apw@canonical.com> wrote:
> > >
> > > Thanks thats great.  I think I have this fixed in my tree now.  Can you
> > > test with the version at the url below:
> > >
> > >  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing
> > >
> > 
> > Thanks Andy, this works for me.
> 
> Could we please push this fix upstream ASAP?

Sure.  Thing.  I only have a couple of patches in my queue.

-apw
