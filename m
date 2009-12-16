Return-Path: <linux-kernel-owner+w=401wt.eu-S1762216AbZLPPGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216AbZLPPGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762200AbZLPPGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:06:34 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:47628 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760389AbZLPPGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:06:33 -0500
Date: Wed, 16 Dec 2009 10:06:04 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Kyle McMartin <kyle@mcmartin.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: anyone including <linux/perf_counter.h>?
In-Reply-To: <20091216150442.GN28962@bombadil.infradead.org>
Message-ID: <alpine.LFD.2.00.0912161004510.8096@localhost>
References: <alpine.LFD.2.00.0912160939510.7588@localhost> <20091216145120.GL28962@bombadil.infradead.org> <alpine.LFD.2.00.0912160955420.7853@localhost> <20091216145851.GM28962@bombadil.infradead.org> <alpine.LFD.2.00.0912161000130.7970@localhost>
 <20091216150442.GN28962@bombadil.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
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

On Wed, 16 Dec 2009, Kyle McMartin wrote:

> On Wed, Dec 16, 2009 at 10:01:39AM -0500, Robert P. J. Day wrote:
> >
> >   1) add it into Kbuild, since user-space needs it, or
> >
> >   2) delete it entirely since it's never been in user-space all
> >      this time but no one seems to have missed it.  :-)
> >
>
> My guess is the latter, since it was never exported. I just noticed
> that Chuck added it to Kbuild after the rename, so it has never been
> exported at all with the previous interface.

  sounds fair.  deletion patch coming soon.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
