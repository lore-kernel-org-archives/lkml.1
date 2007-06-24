Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbXFXAlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbXFXAlN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 20:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXFXAlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 20:41:00 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:39893 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbXFXAk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 20:40:58 -0400
X-Greylist: delayed 1795 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jun 2007 20:40:58 EDT
Message-ID: <467DBD8B.1010900@nttdata.co.jp>
Date: Sun, 24 Jun 2007 09:40:43 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
CC: Chris Wright <chrisw@sous-sol.org>, Chris Mason <chris.mason@oracle.com>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Lars Marowsky-Bree <lmb@suse.de>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain> <20070622140240.GM6222@think.oraclecorp.com> <Line.LNX.4.64.0706221012340.6190@localhost.localdomain> <20070622173056.GA873@think.oraclecorp.com> <20070623001149.GI3457@sequoia.sous-sol.org> <467DB682.5070903@nttdata.co.jp>
In-Reply-To: <467DB682.5070903@nttdata.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2007 00:40:45.0937 (UTC) FILETIME=[4D74DE10:01C7B5F8]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This thread is amazing.  With so many smart people's precious time,
> 
> What are the results?
> What are the issues anyway?
> Is anyone happy? (I'm not and I assume Chris is not)
> 
> Yes, "waste of time" is taking place here, but
> it's not for "pathname-based MAC" but for "wrongly posted messages",
> I believe.  I'm a relatively new to this ml, let me ask.
> 
> Is this ml a place of judge or battle? (not to help or support?)
> 
> Nothing is perfect, so we can work to make things to better, right?
> I have suggestions:
> 
> Let's clarify issues first.
> - problems (or limitations) of pathname-based MAC
> - advantages of pathname-based MAC
> - how can pathname-based MAC supplement label based
> (Stephen, James and Kyle, please help)
> 
> Let's start the arguments again if we get the issues.
> Threads should be definitely separated per issue and
> a assigning a chair may help.

Well, I crated a Wiki page. If it helps, please
feel free to use it.  I mean I would like
people to add your issues here.  It's wiki, so
you are welcome to modify everything.

http://tomoyo.sourceforge.jp/wiki-e/?MAC-ISSUES

If ml is better, I have no objections.
I just wanted to help discussion.

> Above issues are independent of SELinux. We should not *compare*
> SELinux and AA, that can cause a problem. Every software has
> shortages that's why we need to work and we can make progress.
> For some issues we may need to compare them, in that case
> moderators would help.
> 
> BTW I have posted a RFC of TOMOYO Linux that is another
> pathname-based MAC.
> http://lkml.org/lkml/2007/6/13/58
> AA and TOMOYO Linux have BoF sessions at OLS2007,
> so it would be a great opportunity to *talk* over the issues.
> 
> What I want to say is "let's make progress and help each other
> to make Linux better".

Cheers,
Toshiharu Harada

