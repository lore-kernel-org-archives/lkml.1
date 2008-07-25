Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYGYMK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYGYMK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 08:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYGYMKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 08:10:49 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40207 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYGYMKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 08:10:48 -0400
Date: Fri, 25 Jul 2008 08:08:50 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how much stuff is no longer "EXPERIMENTAL"?
In-Reply-To: <20080724211141.4fa557ca@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0807250806370.3366@localhost.localdomain>
References: <alpine.LFD.1.10.0807241114000.4119@localhost.localdomain> <h2ih845fmasm3coi3qapmqkknj0ghp6k7t@4ax.com> <alpine.LFD.1.10.0807241606240.6474@localhost.localdomain> <20080724211141.4fa557ca@lxorguk.ukuu.org.uk>
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

On Thu, 24 Jul 2008, Alan Cox wrote:

> > legitimately experimental content in the source tree.  surely
> > *some* of that is suitably mature such that that dependency can be
> > dropped.
>
> What is the connection between age of code and experimental status ?

  perhaps nothing, perhaps lots.  *of course* there can be features
that are both long-lived and still experimental.  just as, of course,
there is stuff that was (properly) tagged as EXPERIMENTAL ages ago
that has long since stabilized and can afford to stop being
experimental.

  just a small nagging for folks to take a quick look at what no
longer needs to be tagged that way, that's all.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
