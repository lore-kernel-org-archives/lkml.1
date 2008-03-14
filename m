Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYCNIIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYCNIIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 04:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYCNII2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 04:08:28 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:52766 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYCNII1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 04:08:27 -0400
Date: Fri, 14 Mar 2008 04:07:41 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: mws@twisted-brains.org
cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whose job is it to include various header files?
In-Reply-To: <47DA1F8B.7040400@twisted-brains.org>
Message-ID: <alpine.LFD.1.00.0803140405510.3148@localhost.localdomain>
References: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain> <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com> <47DA1F8B.7040400@twisted-brains.org>
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

On Fri, 14 Mar 2008, mws@twisted-brains.org wrote:

> what i said in my first sentence is the imho proper way: if you
> alter sources and includes get obsolete, remove them and fix
> compiling again for files that formerly depended (implicit or
> explicit) on this altered sources. not to much work for the
> developer himself and also not exhausting the compile times.

and, in my defense, that's what i *thought* i was doing, not having
noticed that one of those "unnecessary" #includes really was
required after all.  argh.  that was embarrassing.

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
