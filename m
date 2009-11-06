Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbZKFStO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbZKFStO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbZKFStN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:49:13 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:38466 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172AbZKFStM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:49:12 -0500
Date: Fri, 6 Nov 2009 10:48:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-11-01-10-01 uploaded
Message-Id: <20091106104851.320a97ee.randy.dunlap@oracle.com>
In-Reply-To: <c1f41c620911060439j42329608u74f937ac9f9ac617@mail.gmail.com>
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
	<alpine.LFD.2.00.0911052010050.12138@localhost.localdomain>
	<661de9470911060338q66746acbr219eedc24e752ca9@mail.gmail.com>
	<c1f41c620911060439j42329608u74f937ac9f9ac617@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AF46FA0.0135:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009 19:39:30 +0700 Emmanuel Benisty wrote:

> On Fri, Nov 6, 2009 at 6:38 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > On Fri, Nov 6, 2009 at 12:43 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> On Sun, 1 Nov 2009, akpm@linux-foundation.org wrote:
> >>
> >>> The mm-of-the-moment snapshot 2009-11-01-10-01 has been uploaded to
> >>>
> >>>    http://userweb.kernel.org/~akpm/mmotm/
> >>>
> >>> and will soon be available at
> >>
> >> Does "soon" mean within this century ?
> >>
> >>>    git://git.zen-sources.org/zen/mmotm.git
> >>
> >> # git pull git://git.zen-sources.org/zen/mmotm.git master
> >> git.zen-sources.org[0: 216.98.141.250]: errno=Connection timed out
> >> git.zen-sources.org[0: 69.72.142.98]: errno=Connection refused
> >> fatal: unable to connect a socket (Connection refused)
> >>
> > I've seen that too, in fact I can't even reach the domain. I've pinged
> > the owner but not heard back yet.
> 
> 
> FTR, it moved to git://zen-kernel.org/kernel/mmotm.git and the
> ownership has changed.

Thanks.  so that mmotm.git is now 5 weeks old.
http://git.zen-kernel.org/?p=kernel/mmotm.git;a=summary

---
~Randy
