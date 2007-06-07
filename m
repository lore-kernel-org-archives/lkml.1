Return-Path: <linux-kernel-owner+w=401wt.eu-S936778AbXFGVBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936778AbXFGVBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbXFGVA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:00:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbXFGVA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:00:59 -0400
Message-ID: <466871F9.9090306@redhat.com>
Date: Thu, 07 Jun 2007 17:00:41 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <1181206091.3625.9.camel@lov.localdomain> <4667D2DF.30207@googlemail.com> <1181228660.3625.23.camel@lov.localdomain> <46682385.1060802@redhat.com> <20070607154342.GA16911@suse.de> <20070607085200.f8d6e2d3.akpm@linux-foundation.org> <20070607155953.GA17591@suse.de> <20070607090632.cfcf02e6.akpm@linux-foundation.org> <20070607161525.GA18363@suse.de> <20070607184805.GA28551@nostromo.devel.redhat.com> <20070607200102.GA21653@suse.de>
In-Reply-To: <20070607200102.GA21653@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Jun 07, 2007 at 02:48:05PM -0400, Bill Nottingham wrote:
>> Greg KH (gregkh@suse.de) said: 
>>> There are a number of distros out there right now who can support that
>>> option disabled.  I'm pretty sure they are the following right now:
>>> 	Gentoo unstable (actually stable works now for me, but I'm not
>>> 			 going to guarantee it just yet...)
>>> 	Debian unstable (again stable might work, but I have not heard
>>> 			 any reports from testers.)
>>> 	openSUSE FACTORY (the 10.3 alpha releases)
>>>
>>> and now it sounds like Red Hat rawhide will also work properly.
>> I suspect while it will work for mkinitrd, the installer will not
>> work properly.
> 
> Ah, but the installer doesn't matter until you do a Fedora 8 release,
> right?  This is just for people who want to run their own kernel on an
> already-set-up Fedora machine.

Eh, not so sure that's true.  It's really kudzu rather than the 
installer itself, and that's used by, for example, system-config-network.

-- 
   Peter
