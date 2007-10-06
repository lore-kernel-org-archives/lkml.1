Return-Path: <linux-kernel-owner+w=401wt.eu-S1763521AbXJFPy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763521AbXJFPy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 11:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760152AbXJFPys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 11:54:48 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46356 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760134AbXJFPyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 11:54:47 -0400
X-Originating-Ip: 99.236.101.138
Date: Sat, 6 Oct 2007 11:51:59 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: apparently missing include/linux header files
In-Reply-To: <8bd0f97a0710060732k423eec3ar8a6cdc64bcaf373@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710061150090.22349@localhost.localdomain>
References: <Pine.LNX.4.64.0710060544270.2942@localhost.localdomain>
 <8bd0f97a0710060732k423eec3ar8a6cdc64bcaf373@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2007, Mike Frysinger wrote:

> On 10/6/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> >   the result of running a quick and dirty shell script that
> > locates inclusions of header files under "include/linux" where
> > those header files don't appear to exist.  (i didn't look any more
> > closely at the results and, apparently, these missing header files
> > aren't fatal since the builds still work but it's just FYI.)
>
> the ones related to kgdb are "normal" ... they require the kgdb patch
> to be applied and if it isnt, then it isnt possible to build the files
> in question

well, like i said, i didn't do any sanity checking on that list, so
i'm sure there are going to be a few false positives.  i just thought
i'd throw that list out there in case there was anything genuinely
problematic so it could be resolved before the next release.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
