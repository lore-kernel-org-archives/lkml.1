Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbYD2SmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbYD2SmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbYD2Slw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:41:52 -0400
Received: from outbound-mail-30.bluehost.com ([69.89.17.212]:60018 "HELO
	outbound-mail-30.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757626AbYD2Slv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:41:51 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: PCI tree info
Date: Tue, 29 Apr 2008 11:41:43 -0700
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
References: <200804291100.08622.jbarnes@virtuousgeek.org> <20080429182717.GA17500@kroah.com>
In-Reply-To: <20080429182717.GA17500@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291141.44023.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2008 11:27 am Greg KH wrote:
> On Tue, Apr 29, 2008 at 11:00:08AM -0700, Jesse Barnes wrote:
> > The PCI tree now lives in git:
> > git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.  There are
> > a few branches:
> >   for-linus - stuff headed to Linus in the next pull request
> >   linux-next - patches targetted at the following release
> >   master - unmodified Linus upstream branch
> >
> > I'll try to avoid re-basing, but since the main downstream tree is the
> > PCI hotplug tree, and Kristen uses quilt, that probably won't be much of
> > an issue.
>
> You should send in a patch to MAINTAINERS to point to this new tree
> there.

Yep, already done.

Thanks,
Jesse
