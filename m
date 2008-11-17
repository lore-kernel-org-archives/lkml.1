Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYKQQdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYKQQdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYKQQdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:33:06 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:43034 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYKQQdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:33:05 -0500
Date: Mon, 17 Nov 2008 08:32:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] bug fixes for 9p linux-2.6.28-rc4
Message-Id: <20081117083247.8b91e965.randy.dunlap@oracle.com>
In-Reply-To: <a4e6962a0811151228h14679d35m56eceff433e518f9@mail.gmail.com>
References: <a4e6962a0811141425n119d624bk8a1a0e3b9c3a9eab@mail.gmail.com>
	<alpine.LFD.2.00.0811151139190.3468@nehalem.linux-foundation.org>
	<a4e6962a0811151228h14679d35m56eceff433e518f9@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.49219CB3.0044:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2008 14:28:45 -0600 Eric Van Hensbergen wrote:

> sorry - just cut n' pasted the output of git-request-pull, didn't
> notice it didn't tag on a diffstat, maybe I have an old buggy version
> of git.
> 
>             -eric
> 
> 
> On Sat, Nov 15, 2008 at 1:40 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Fri, 14 Nov 2008, Eric Van Hensbergen wrote:
> >>
> >> The following changes since commit 4ff429e658c00bcf5101eabbebd4f711572a64cb:
> >>   Randy Dunlap (1):
> >>         9p: restrict RDMA usage
> >>
> >> are available in the git repository at:
> >>
> >>   ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus
> >
> > Diffstat?
> >
> > Yeah, I see that it is
> >
> >  net/9p/Kconfig |   10 ++++++----
> >  1 files changed, 6 insertions(+), 4 deletions(-)
> >
> > but I want to know things like that _before_ pulling, just to know what to
> > expect, and so that I know that what I pull is what you meant me to pull.

Eric,

See Documentation/SubmittingPatches:  16) Sending "git pull" requests
It details the pull request and the expected diffstat.

---
~Randy
