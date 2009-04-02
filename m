Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZDBEnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZDBEnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZDBEnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:43:08 -0400
Received: from blaine.gmane.org ([80.91.229.8]:36550 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbZDBEnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:43:06 -0400
From: Miles Bader <miles@gnu.org>
To: David Howells 
	<public-dhowells-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org>
Cc: Linus Torvalds 
	<public-torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@hugh.gmane.org>,
       Trond Myklebust 
	<public-Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@hugh.gmane.org>,
       public-linux-nfs-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
Subject: Re: [GIT PULL] Please pull the first batch of NFS client changes (and cachefs merge)...
References: <alpine.LFD.2.00.0904010935000.4130@localhost.localdomain>
	<1238522824.6577.5.camel@heimdal.trondhjem.org>
	<19756.1238606665@redhat.com>
Reply-To: Miles Bader <miles@gnu.org>
System-Type: x86_64-unknown-linux-gnu
Blat: Foop
Date: Thu, 02 Apr 2009 13:33:40 +0900
In-Reply-To: <19756.1238606665@redhat.com> (David Howells's message of "Wed,
	01 Apr 2009 18:24:25 +0100")
Message-ID: <buoprfv8yjf.fsf@dhlpc061.dev.necel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-TMDA-Confirmed: Thu, 02 Apr 2009 06:42:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>> What the hell is that "cf-" and "fsc-" prefix?
>
> One editor with many files open all of the same base name (namei.c, proc.c,
> security.c, xattr.c, page.c for example).

If it's emacs, try enabling `uniquify', e.g.:

   M-x load-library RET uniquify RET
   M-x customize-variable RET uniquify-buffer-name-style RET

It will name your buffers nicely incorporating enough of the leading
path to make them unique.

[I like the `post-forward' style myself...]

-Miles

-- 
Inhumanity, n. One of the signal and characteristic qualities of humanity.


