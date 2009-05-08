Return-Path: <linux-kernel-owner+w=401wt.eu-S1764126AbZEHXDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbZEHXDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbZEHXDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:03:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118AbZEHXDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:03:22 -0400
Date: Fri, 8 May 2009 15:59:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: udovdh@xs4all.nl, linux-kernel@vger.kernel.org,
       Rodolfo Giometti <giometti@linux.it>, Christoph Hellwig <hch@lst.de>
Subject: Re: LinuxPPS status?
Message-Id: <20090508155935.3e88e49e.akpm@linux-foundation.org>
In-Reply-To: <20090508112722.040e99ee@lxorguk.ukuu.org.uk>
References: <4A0406C3.7000507@xs4all.nl>
	<20090508112722.040e99ee@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009 11:27:22 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Fri, 08 May 2009 12:17:39 +0200
> Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> 
> > Hello,
> > 
> > Can anybody please give a summary of the things needing work before 
> > LinuxPPS can go into the kernel?
> > Andrew posted something in february but are his objections still valid?
> > 
> > Can we just fix the final bits and have it in the kernel whenever the 
> > first occasion comes along?
> 
> If you are getting no feedback just submit it next merge window. Either
> its offended nobody or they've forgotten to notice - in both cases
> submitting it will have the desired effect.

As far as I know the master version is sitting in -mm.  This thing has
gone on for so long and with such large intervals between activity that
I've forgotten what the outstanding issues are, if any.

I have a note here that Christoph had requested that the pps header
file be split in some fashion (user and kernel?) but that doesn't
appear to have happened in my copy of the patch.

Probably it would be best to start again, resend the patch with 1000 cc's,
re-review and actually get it over the line.

