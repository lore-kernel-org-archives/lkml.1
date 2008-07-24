Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbYGXUIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbYGXUIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYGXUIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:08:07 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:57409 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYGXUIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:08:06 -0400
Date: Thu, 24 Jul 2008 16:06:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Grant Coady <gcoady.lk@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how much stuff is no longer "EXPERIMENTAL"?
In-Reply-To: <h2ih845fmasm3coi3qapmqkknj0ghp6k7t@4ax.com>
Message-ID: <alpine.LFD.1.10.0807241606240.6474@localhost.localdomain>
References: <alpine.LFD.1.10.0807241114000.4119@localhost.localdomain> <h2ih845fmasm3coi3qapmqkknj0ghp6k7t@4ax.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008, Grant Coady wrote:

> On Thu, 24 Jul 2008 11:14:22 -0400 (EDT), "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> >  how about a concerted effort to remove inappropriate EXPERIMENTAL
> >dependencies from the Kconfig files?  there must be a truckload of
> >stuff that has long since matured beyond EXPERIMENTAL status that is
> >still tagged that way.
>
> I sent a patch to remove EXPERIMENTAL on a three year old driver
> couple months ago, it got Acked by maintainer, hwmon/adm9240.  But I
> dunno if the patch is queued somewhere or lost.

at last count, there were 437 config selections that were tagged as
EXPERIMENTAL.  i find it hard to believe that there's that much
legitimately experimental content in the source tree.  surely *some*
of that is suitably mature such that that dependency can be dropped.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
