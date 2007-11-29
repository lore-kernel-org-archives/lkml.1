Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbXK2F1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbXK2F1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 00:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXK2F1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 00:27:39 -0500
Received: from [212.12.190.53] ([212.12.190.53]:33766 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750857AbXK2F1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 00:27:38 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: git guidance
Date: Thu, 29 Nov 2007 08:27:04 +0300
User-Agent: KMail/1.5
Cc: git@vger.kernel.org
References: <20071127235237.GF15227@1wt.eu> <Pine.LNX.4.64.0711281811500.27959@racer.site> <200711282130.12864.a1426z@gawab.com>
In-Reply-To: <200711282130.12864.a1426z@gawab.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711290827.04950.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Narebski wrote:
> Al Boldi wrote:
> > Johannes Schindelin wrote:
> >> By that definition, no SCM, not even CVS, is transparent.  Nothing
> >> short of unpacked directories of all versions (wasting a lot of disk
> >> space) would.
> >
> > Who said anything about unpacking?
> >
> > I'm talking about GIT transparently serving a Virtual Version Control
> > dir to be mounted on the client.
>
> Are you talking about something like (in alpha IIRC) gitfs?
>
>   http://www.sfgoth.com/~mitch/linux/gitfs/

This looks like a good start.

> Besides, you can always use "git show <revision>:<file>". For example
> gitweb (and I think other web interfaces) can show any version of a file
> or a directory, accessing only repository.

Sure, browsing is the easy part, but Version Control starts when things 
become writable.


Thanks for the link!

--
Al

