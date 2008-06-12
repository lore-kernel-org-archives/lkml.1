Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYFLWTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYFLWTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYFLWT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:19:27 -0400
Received: from outbound-mail-120.bluehost.com ([69.89.18.6]:41718 "HELO
	outbound-mail-120.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754263AbYFLWT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:19:26 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] final PCI patches for 2.6.26
Date: Thu, 12 Jun 2008 15:19:24 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200806121334.01562.jbarnes@virtuousgeek.org> <485198E5.80109@garzik.org>
In-Reply-To: <485198E5.80109@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121519.24194.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 12, 2008 2:45 pm Jeff Garzik wrote:
> Jesse Barnes wrote:
> > Some of these may not have seen review on linux-pci, so I'm sending them
> > out for comment before I send Linus the pull request.
> >
> > Any comments/objections?
> >
> > The biggest patch by far is the resource_wc stuff; it should have been
> > pushed earlier, but for some reason I thought Ingo & co. were going to do
> > that...
> >
> > Thanks,
> > Jesse
> >
> > commit a123c3d9643464c56417680536ed9515f15cffa1
> > Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
> > Date:   Mon May 12 21:21:05 2008 +0200
>
> Although I quite appreciate the addition of patches, IMO it would be
> easier to read if the patch descriptions and patches were not mixed
> together.
>
> Most 'git pull' things I've seen include a changeset summary (shortlog)
> and cumulative patch, when its a single email.  Sometimes (i.e. GregKH
> and a few others) the individual patches are posted in separate emails.

Right, I probably should have used one of the git mail scripts... but this 
wasn't a real git pull request either, more of a "hey please sanity check 
this" type thing.  I figured in this case keeping the changelogs was 
important, but didn't want to spam people with a bunch of messages when the 
total size really wasn't that big...

Jesse
