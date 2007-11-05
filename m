Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbXKEDuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbXKEDuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 22:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXKEDuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 22:50:39 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:35230 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXKEDui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 22:50:38 -0500
Date: Sun, 4 Nov 2007 22:49:12 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Marco Costalba <mcostalba@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: duplicated include files
In-Reply-To: <472E53D0.2000204@goop.org>
Message-ID: <Pine.LNX.4.64.0711042248220.30791@localhost.localdomain>
References: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com>
 <e5bfff550711041143i7be3cff7kd4903ed43cb4e232@mail.gmail.com>
 <Pine.LNX.4.64.0711041447330.6072@localhost.localdomain> <472E53D0.2000204@goop.org>
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

On Sun, 4 Nov 2007, Jeremy Fitzhardinge wrote:

> Robert P. J. Day wrote:
> > actually, one wonders if there's any value in keeping any references
> > to other version control systems such as subversion, SCCS, CVS,
> > mercurial, etc.
>
> What do you mean by "other"?  git doesn't have a monopoly, and the
> kernel should support people using a reasonable set of version
> control systems.  Supporting VSS would be strange, but nothing wrong
> with the set you listed, if people find those systems useful.  It's
> not like it amounts to a huge amount of effort to do so.

you're right, my mistake, i was just caught up in a git-centered
perspective.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
