Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbZDJQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbZDJQES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758321AbZDJQEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:04:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55607 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324AbZDJQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:04:00 -0400
Date: Fri, 10 Apr 2009 17:03:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-ID: <20090410160353.GP26366@ZenIV.linux.org.uk>
References: <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org> <20090409003308.GK16602@bilbo.ozlabs.org> <20090408174443.79e71503.akpm@linux-foundation.org> <20090409215207.GN16602@bilbo.ozlabs.org> <20090409234750.GE7921@lug-owl.de> <20090410101220.GF7921@lug-owl.de> <8bd0f97a0904100319kb16c81bs596341e016cc41a@mail.gmail.com> <20090410104913.GA21483@uranus.ravnborg.org> <20090410155916.GH7921@lug-owl.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410155916.GH7921@lug-owl.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 05:59:16PM +0200, Jan-Benedict Glaw wrote:
> On Fri, 2009-04-10 12:49:13 +0200, Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Fri, Apr 10, 2009 at 06:19:21AM -0400, Mike Frysinger wrote:
> 
> > I'm after a one-stop place where we can locate cross compilers
> > for all architectures that Linux supports so it is a much simpler
> > task to actaully try to build our changes for as many architectures
> > as we supports.
> > 
> > And please host them on kernel.org - preferably as an update
> > of Vegards pages.
> 
> Known-working compilers, or the current latest-and-greatest for
> testing? I can provide the HEAD compilers easily.

There's /pub/scm/linux/kernel/git/viro/toolchain.git/ on kernel.org.
Not updated for a while and it's Fedora-based set.
