Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbXKDTug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbXKDTug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbXKDTu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:50:28 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:50883 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbXKDTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:50:28 -0500
Date: Sun, 4 Nov 2007 14:49:08 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Marco Costalba <mcostalba@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: duplicated include files
In-Reply-To: <e5bfff550711041143i7be3cff7kd4903ed43cb4e232@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711041447330.6072@localhost.localdomain>
References: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com>
 <e5bfff550711041143i7be3cff7kd4903ed43cb4e232@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2007, Marco Costalba wrote:

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

actually, one wonders if there's any value in keeping any references
to other version control systems such as subversion, SCCS, CVS,
mercurial, etc.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
