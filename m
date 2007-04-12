Return-Path: <linux-kernel-owner+w=401wt.eu-S2992599AbXDLP7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992599AbXDLP7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992602AbXDLP7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:59:49 -0400
Received: from eazy.amigager.de ([213.239.192.238]:43925 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992600AbXDLP7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:59:48 -0400
Date: Thu, 12 Apr 2007 17:59:46 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] UDF cleanup and fixes
Message-ID: <20070412155946.GA7613@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20070306164447.GC3661@duck.suse.cz> <20070330045923.GA5528@dose.home.local> <460D51AA.2080307@redhat.com> <20070331094631.GA24220@thinkpad.home.local> <461117BB.5040705@redhat.com> <20070404063620.GA5465@dose.home.local> <20070412160112.GD23348@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412160112.GD23348@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 18:01:12 +0200, Jan Kara wrote:
> On Wed 04-04-07 08:36:20, Tino Keitel wrote:
> > On Mon, Apr 02, 2007 at 10:48:27 -0400, Chuck Ebbert wrote:
> > 
> > [...]
> > 
> > > Well, it works for me on 32-bit as well, right up to 100% full.
> > > No problems at all...
> > 
> > Maybe it depends on the kernel. I patched 2.6.20 with the patches
> > above and got the described behaviour.
>   I've sent you an email with a few questions but probably it got lost in
> the noise... Are you able to reproduce the problem? Have you reproduced the
> problem on a freshly created UDF image or was it some older image?

Hi,

I can't remember of any errors in the kernel or about not available
space. It was an image file that I expermimented with, and I did
multiple mkudffs runs on the file. Could it be that the behaviour was
caused by stale data inside the image?

Regards,
Tino

