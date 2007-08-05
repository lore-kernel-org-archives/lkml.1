Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbXHEQiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbXHEQiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbXHEQiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:38:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52174 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbXHEQiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:38:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: Linux 2.6.23-rc2
Date: Sun, 5 Aug 2007 18:47:11 +0200
User-Agent: KMail/1.9.5
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com> <1186317610.5220.3.camel@daplas> <b6a2187b0708050626s15e1b7did73f638046c0dba3@mail.gmail.com>
In-Reply-To: <b6a2187b0708050626s15e1b7did73f638046c0dba3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708051847.12046.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 5 August 2007 15:26, Jeff Chua wrote:
> On 8/5/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> 
> > Can you try with the boot option acpi_sleep=s3_bios,s3_mode
> > OR
> > if using s2ram, use s2ram -f a3
> 
> Tried both, text-console still not restored.
> 
> In fact, with "s2ram -f a3", backlight doesn't get restored. I've to
> switch to F1 and back to X to get backlight to come back on.
> 
> One way to get console back is to "suspend-to-disk", and upon resume,
> text-console works just fine.

What does 's2ram -i' say about your machine?

Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
