Return-Path: <linux-kernel-owner+w=401wt.eu-S1765060AbXFFPPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765060AbXFFPPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758739AbXFFPPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:15:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:13237 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717AbXFFPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:15:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oNErYG9M28WrN68mO0CU8vrSnMiAQcFimlZnZimRVvDn9IpKKwXP1rutzHhmFqlq4V4HCzOe/zgaA2eeb+ZEBk/iMXxFrqT+qXqqdZzw21W+YIk6LemVIL7LlEZlF31k+xMPKN22dbMTW6Wb9S3+PvGdq8L5lkp9ca6NaUvZ1II=
Message-ID: <9a8748490706060815uefaa75bh106b30a00f63fb54@mail.gmail.com>
Date: Wed, 6 Jun 2007 17:15:22 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: tim.post@netkinetics.net
Subject: Re: Kernel inclusion policy, meta desicion making structure?
Cc: linux-kernel@vger.kernel.org, "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <4666C73F.6080208@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1180928198.5786.111.camel@localhost.localdomain>
	 <4666C73F.6080208@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Tim Post wrote on 2007-06-04:
> > I was wondering if a meta version of the decision making process that
> > would be employed to determine if a new contribution does or does not go
> > into the main stream Linux kernel.
> [...]
> > Does some document exist that shows the decision making process so that
> > I can easily answer the ultimate question of "Why not" for myself?
>
> There is documentation on how submissions should look like.

Some starting points:

Documentation/HOWTO
Documentation/SubmittingDrivers
Documentation/SubmittingPatches
Documentation/SubmitChecklist
Documentation/ManagementStyle

> Other than
> that, these are case-by-case decisions based on a number of factors.
> Perhaps you should look up discussions on merge requests (accepted as
> well as rejected ones) in archives or better at sources like LWN.net.
>

Good LKML archives to search :

http://marc.info/?l=linux-kernel
http://lkml.org/

Sometimes good summaries of discussions / decision making processes
can also be found at http://kerneltrap.org/

You can also search the ChangeLog messages for different patches
easily via git-web:
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=summary

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
