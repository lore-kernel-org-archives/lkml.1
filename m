Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbXJLAMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbXJLAMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 20:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbXJLAMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 20:12:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39681 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbXJLAMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 20:12:34 -0400
Date: Thu, 11 Oct 2007 17:10:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Rob Landley <rob@landley.net>, linux-scsi@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Scsi on sparc build break in 2.6.23.
Message-Id: <20071011171042.582a22d4.randy.dunlap@oracle.com>
In-Reply-To: <20071011235659.GB3620@stusta.de>
References: <200710110552.49129.rob@landley.net>
	<200710110817.22344.rob@landley.net>
	<20071011152149.GZ16424@stusta.de>
	<200710111737.30420.rob@landley.net>
	<20071011235659.GB3620@stusta.de>
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

On Fri, 12 Oct 2007 01:56:59 +0200 Adrian Bunk wrote:

> On Thu, Oct 11, 2007 at 05:37:30PM -0500, Rob Landley wrote:
> > On Thursday 11 October 2007 10:21:49 am Adrian Bunk wrote:
> > > I assume you have the full .config in your build directory, and could
> > > have taken it from there?
> > 
> > Actually I don't.  (The extracted source tree is in a temporary directory 
> > which the script deletes afterwards unless I tell it not to.  I just followed 
> > my own instructions to create the .config and attach it, but I see that James 
> > Bottomley already diagnosed it and you came up with a patch.  Off to try 
> > it...)
> 
> I was able to follow your instructions for generating it.
> 
> But I hope you got my point that it's much easier to debug such issues 
> when you generate the .config yourself and attach it when sending the 
> bug report.

I use the mini-config method quite a bit (probably not as much
as Rob does), but I agree with Adrian, it should have just been
included here in full (not mini).

---
~Randy
