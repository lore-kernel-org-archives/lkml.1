Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbXFZUT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbXFZUT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 16:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbXFZUTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 16:19:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759837AbXFZUTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 16:19:08 -0400
Date: Tue, 26 Jun 2007 13:18:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-Devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 03/10] define ELF notes for adding to a boot image
Message-Id: <20070626131830.9a4d4ae6.akpm@linux-foundation.org>
In-Reply-To: <4672C0FF.9080209@goop.org>
References: <20070615004818.424726597@goop.org>
	<20070615005012.882738673@goop.org>
	<4672BC5B.1040502@zytor.com>
	<4672C0FF.9080209@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 09:40:31 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> H. Peter Anvin wrote:
> > Jeremy Fitzhardinge wrote:
> >   
> >> +#define EIN_PROGRAM_CHECKSUM	3 /* ip style checksum of the memory image. */
> >>     
> >
> > Why on earth use one of the weakest verificants in common use?
> 
> I don't know.  I copied this stuff from the original relocatable kernel
> patches; I think this is from Vivek.  Eric, Vivek: is there a specific
> use for these notes?
> 

ping?


Jeremy, I'll duck these patches for now, sorry.  Mainly on
i-already-have-enough-x86-stuff grounds.

There's a bit of overlap between this work and git-newsetup, but nothing
particularly serious-looking.

