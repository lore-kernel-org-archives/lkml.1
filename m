Return-Path: <linux-kernel-owner+w=401wt.eu-S933454AbXEPSSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbXEPSSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbXEPSSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:18:47 -0400
Received: from ires.in2p3.fr ([193.48.86.184]:35164 "EHLO IReS.in2p3.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbXEPSSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:18:47 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 14:18:46 EDT
Message-ID: <464B4911.4050903@free.fr>
Date: Wed, 16 May 2007 20:10:25 +0200
From: Goulven Guillard <lecotegougdelaforce@free.fr>
Reply-To: lecotegougdelaforce@free.fr
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B4155.9070902@gmail.com> <464B43BB.3070505@redhat.com>
In-Reply-To: <464B43BB.3070505@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 05/16/2007 07:47 PM, Chuck Ebbert a déclaré :

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=11ccc0f249cb01a129f54760b8ff087f242935d4
> Commit:     11ccc0f249cb01a129f54760b8ff087f242935d4
> Parent:     de46c33745f5e2ad594c72f2cf5f490861b16ce1
> Author:     Len Brown <len.brown@intel.com>
> AuthorDate: Mon Apr 30 22:36:01 2007 -0400
> Committer:  Len Brown <len.brown@intel.com>
> CommitDate: Mon Apr 30 22:36:01 2007 -0400
> 
>     ACPI: thermal trip points are read-only


Should one understand that it IS a wanted behaviour ?

Isn't it the DSDT job (which is kernel-accessible, or isn't it ?) to
communicate trip_points to ACPI thermal zone ?

Isn't OSPM managing thermal zone ?

(http://acpi.sourceforge.net/documentation/thermal.html)




PS : Sorry for all these (maybe stupid) questions, but I think I
remember that changing trip_points had an effect on a (DSDT-bugged)
laptop I used to use, and I'd like to understand...

PPS : Sorry also for the english mistakes or approximations...




-- 
    ~~
   |Oo|   La banquise fond !!! Adoptez un pingouin...
  /|\/|\
   |__|            => http://doc.ubuntu-fr.org/
   ^__^
~~~|  |~~~








