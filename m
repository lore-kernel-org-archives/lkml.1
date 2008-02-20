Return-Path: <linux-kernel-owner+w=401wt.eu-S1763858AbYBTAVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763858AbYBTAVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbYBTAVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:21:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52171 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286AbYBTAVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:21:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [patch] move wakeup code to .c
Date: Wed, 20 Feb 2008 01:20:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, hpa@zytor.com,
       sam@ravnborg.org
References: <20080210222723.GA1865@elf.ucw.cz> <200802151819.23413.lenb@kernel.org> <200802180049.56029.rjw@sisk.pl>
In-Reply-To: <200802180049.56029.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802200120.08448.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of February 2008, Rafael J. Wysocki wrote:
> On Saturday, 16 of February 2008, Len Brown wrote:
> > On Friday 15 February 2008 17:22, Rafael J. Wysocki wrote:
> > 
> > > Ok, below is the version that survives checkpatch.pl, compiles on x86-32
> > > and has been successfully tested on 32-bit and 64-bit systems.
> > 
> > works on my t61 in 64-bit mode too.
> > 
> > applied to acpi-test.
> 
> Below is an updated version of this patch, addressing the following problem
> reports related to it:
> http://lkml.org/lkml/2008/2/16/178
> http://lkml.org/lkml/2008/2/16/74
> http://marc.info/?l=linux-acpi&m=120313725501682&w=4
> 
> Please replace the previous version with this one.

Please disregard it, I'm going to send an updated version in a while.

Thanks,
Rafael
