Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZBWRKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZBWRKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZBWRKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:10:42 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:36056 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZBWRKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:10:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AWN4y2UBIT4Pp8Zm/XUPV4Y0wicW3CzwPzl/Tor5yACjfy54q660XrZlICDHM9Wuzl
         Dy1zBYIViMqksor8HGAvJlH2+GPKdauYAXBx0gKG8OrWvPrVRLIgj0pyZ/TiQ6R8COqz
         h909gowX9gxfcajekQzI+TOAUZyo8YvqulOFY=
Date: Mon, 23 Feb 2009 18:10:32 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: "eial@cs.bgu.ac.il" <eial@cs.bgu.ac.il>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel panic on 2.6.28
Message-ID: <20090223171030.GA5925@joi>
References: <200902201924.n1KJOsRw027332@indigo.cs.bgu.ac.il> <200902230638.n1N6cg06015206@indigo.cs.bgu.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902230638.n1N6cg06015206@indigo.cs.bgu.ac.il>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 08:38:42AM +0200, eial@cs.bgu.ac.il wrote:
> On Fri 20 Feb 21:24 2009 eial@cs.bgu.ac.il wrote:
> > 
> > hello, I'm having a kernel panic with kernel 2.6.28 upon shutdown right after unmounting remaining file system under gentoo.
> > I've enabled kernel dump feature in the kernel but I can't seem to be able to locate the file, where can I find it?
> > 
> > thanks
> > 
> > Eial
>
> I apologize of the bump, can anyone help me on this subject?

As I read Documentation/kdump/kdump.txt kdump works in a different way,
so it's a dead end. Does this panic happen on gentoo-sources or vanilla-sources?
If it's on gentoo-sources, test vanilla (if it happens only on gentoo-sources
then file a bug at http://bugs.gentoo.org).

No matter on which kernel it happens, you will have to write down an oops.
You can take a picture of a screen with a camera.

And then read REPORTING-BUGS in kernel sources.

PS: Please don't top post.

Marcin
