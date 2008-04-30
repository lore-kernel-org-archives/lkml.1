Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbYD3BN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbYD3BN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYD3BNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:13:21 -0400
Received: from outbound-mail-137.bluehost.com ([67.222.39.27]:60192 "HELO
	outbound-mail-137.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751949AbYD3BNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:13:21 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: PCI tree info
Date: Tue, 29 Apr 2008 18:13:14 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
References: <200804291100.08622.jbarnes@virtuousgeek.org> <20080430094742.589add5a.sfr@canb.auug.org.au>
In-Reply-To: <20080430094742.589add5a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291813.14634.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2008 4:47 pm Stephen Rothwell wrote:
> Hi Jesse,
>
> On Tue, 29 Apr 2008 11:00:08 -0700 Jesse Barnes <jbarnes@virtuousgeek.org> 
wrote:
> > The PCI tree now lives in git:
> > git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.  There are
> > a few branches:
> >   for-linus - stuff headed to Linus in the next pull request
> >   linux-next - patches targetted at the following release
>
> I have added both these to linux-next as "pci-current" and "pci"
> respectively.  These have just you as the contact - let me know if you
> want someone else as well (or even a mailing list).

Thanks Stephen.  Can you also keep the linux-pci list in the loop for any 
problems you find?

Thanks,
Jesse
