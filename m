Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbXKDTwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbXKDTwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXKDTv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:51:59 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:41584 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbXKDTv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:51:58 -0500
Date: Sun, 4 Nov 2007 11:51:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Marco Costalba" <mcostalba@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: duplicated include files
Message-Id: <20071104115108.ea8729a2.randy.dunlap@oracle.com>
In-Reply-To: <e5bfff550711041143i7be3cff7kd4903ed43cb4e232@mail.gmail.com>
References: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com>
	<e5bfff550711041143i7be3cff7kd4903ed43cb4e232@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2007 20:43:01 +0100 Marco Costalba wrote:

> On 11/4/07, Marco Costalba <mcostalba@gmail.com> wrote:
> > make includecheck does not work for me. Linux tree is from latest git.
> >
> > bash-3.2$ pwd
> > /git/linux-2.6
> >
> > bash-3.2$ make includecheck
> > find * \( -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS -o
> 
> BTW what's that 'BitKeeper' fossil here?

It allows people to continue using any of {CVS, SVN, BitKeeper}
for their kernel tree.  The BK kernel tree is still being updated
AFAIK.  (It was last time I looked, about 3 weeks ago.)

---
~Randy
