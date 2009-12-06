Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZLFTfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZLFTfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZLFTfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:35:32 -0500
Received: from reaktio.net ([194.89.68.22]:47942 "EHLO ydin.reaktio.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZLFTfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:35:31 -0500
X-Greylist: delayed 1089 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Dec 2009 14:35:31 EST
Date: Sun, 6 Dec 2009 21:17:29 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: "Mr. Teo En Ming (Zhang Enming)" <space.time.universe@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32
Message-ID: <20091206191729.GN16033@reaktio.net>
References: <alpine.LFD.2.00.0912022125400.2872@localhost.localdomain> <f712b9cf0912032103j8c576e1kac0c85a42e2c444f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f712b9cf0912032103j8c576e1kac0c85a42e2c444f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 01:03:03PM +0800, Mr. Teo En Ming (Zhang Enming) wrote:
> On Thu, Dec 3, 2009 at 1:47 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> 
> Dear Torvalds,
> 
> May I know if Xen paravirt-ops dom0 support will be merged upstream
> into Linux kernel 2.6.33?
> 
> Fedora 12's release notes page speculates that support for Xen dom0
> will be available in 2.6.33.
> 
> Thank you very much.
> 

Mr. Teo En Ming: Jeremy is the Xen maintainer, and he hasn't sent pull
request for Xen pv_ops dom0 patches.

I don't think he's going to submit Xen dom0 patches for 2.6.33. You
should talk with Jeremy about it.

-- Pasi

