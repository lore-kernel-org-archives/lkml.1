Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbXKJXrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbXKJXrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 18:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbXKJXrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 18:47:11 -0500
Received: from mx.treblig.org ([80.68.94.177]:2320 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbXKJXrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 18:47:10 -0500
Date: Sat, 10 Nov 2007 23:47:06 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: david@lang.hm
Cc: Crispin Cowan <crispin@crispincowan.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
Message-ID: <20071110234706.GE24195@gallifrey>
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey> <47362C7C.2050202@crispincowan.com> <20071110222414.GC24195@gallifrey> <47363381.4030103@crispincowan.com> <20071110232545.GD24195@gallifrey> <Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 23:43:42 up 16 days, 14:13,  2 users,  load average: 0.61, 0.84, 0.79
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* david@lang.hm (david@lang.hm) wrote:
 That I wrote:
> >If the adminisrator set something up with (2) as the starting point it
> >would seem reasonable for the user to be able to add the ability to edit
> >documents in extra directories for their style of organising documents
> >they work on; but they would be restricted in what they could add
> >so that they couldn't add the ability to write to their settings
> >files.
> 
> but how can the system know if the directory the user wants to add is 
> reasonable or not? what if the user says they want to store their 
> documents in /etc?

I was assuming that in a system where the user can add stuff to
the profile the administrator would be able to either grant or exclude
paths that the user was able to add.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
