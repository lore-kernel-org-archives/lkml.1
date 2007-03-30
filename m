Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbXC3TcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbXC3TcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbXC3TcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:32:17 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38798 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752221AbXC3TcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:32:16 -0400
Date: Fri, 30 Mar 2007 21:32:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: smart gcc inliner...
Message-ID: <20070330193216.GJ14134@stusta.de>
References: <46093349.7060401@agmk.net> <p73ircm4odz.fsf@bingen.suse.de> <4609D92A.3050104@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4609D92A.3050104@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 07:55:38PM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > init functions should only ever be called from other init functions.
> >
> > So this should not happen. If it happens the annotations need to be fixed.
> 
> I've seen some versions of gcc inline weak functions too.

Please be more precise:
- gcc version
- example code
- bug number in the gcc Bugzilla

This would also help understanding what you are talking about:
- Did gcc inline a global function?
- Or was a static function declared as weak (which might be an error
  by the programmer)?
- ...

>     J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

