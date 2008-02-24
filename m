Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYBXPKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYBXPKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYBXPKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:10:04 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:46184 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYBXPKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:10:03 -0500
Date: Sun, 24 Feb 2008 10:09:55 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jiri Slaby <jirislaby@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Remove "obsolete" digiepca content.
In-Reply-To: <47C13FA9.8000806@gmail.com>
Message-ID: <alpine.LFD.1.00.0802241008070.7616@localhost.localdomain>
References: <alpine.LFD.1.00.0802091643030.28397@localhost.localdomain> <47C13FA9.8000806@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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

On Sun, 24 Feb 2008, Jiri Slaby wrote:

> On 02/09/2008 10:45 PM, Robert P. J. Day wrote:
> > Remove the Digi Intl. epca driver for Linux, which is marked as
> > "obsolete."
> >
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> >
> > ---
> >   this is a quick, first pass at a removal.  feel free to suggest
> > tweaks.
>
> Was there any comments on this? I suggest reposting with Cc to akpm.

ok, i'll give it another shot but, given that this discussion has been
happening on and off for well over a year:

http://lkml.org/lkml/2006/10/26/231

i'm starting to wonder whether this is worth anyone's time anymore.
certainly, *i'm* losing interest in posting it every couple of months.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
