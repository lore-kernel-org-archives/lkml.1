Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYG2DtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYG2DtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYG2DtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:49:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbYG2DtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:49:00 -0400
Date: Mon, 28 Jul 2008 20:48:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: MadLoisae@gmx.net, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: kernel oops with framebuffer device vt8623fb
Message-Id: <20080728204817.ebaa621b.akpm@linux-foundation.org>
In-Reply-To: <20080717013917.GA1695@localhost.localdomain>
References: <487E2911.5090701@gmx.net>
	<20080717013917.GA1695@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 03:39:18 +0200 Ondrej Zajicek <santiago@crfreenet.org> wrote:

> On Wed, Jul 16, 2008 at 07:00:02PM +0200, MadLoisae@gmx.net wrote:
> > Hi!
> > 
> > I've updated my machine from 2.6.25.11 to 2.6.26 and I think I've found 
> > a problem.
> > 
> > If I load the module vt8623fb i get a kernel oops, if the VIA 8623 
> > display framebuffer driver is compiled direct into kernel the system 
> > hangs up very early at booting the kernel.
> 
> I am sorry for mistake, here is a patch for 2.6.26 fixing the bug:
> 
> Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>

I went back through the email thread and wrote your changelog for you. 
Not a very good one though.

It would be better were you to write your changelogs, please.
