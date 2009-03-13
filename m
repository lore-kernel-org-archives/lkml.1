Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbZCMWau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbZCMWau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZCMWam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:30:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899AbZCMWam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:30:42 -0400
Date: Fri, 13 Mar 2009 15:28:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc8
In-Reply-To: <49BAD165.5020503@goop.org>
Message-ID: <alpine.LFD.2.00.0903131528440.3940@localhost.localdomain>
References: <alpine.LFD.2.00.0903122102510.3940@localhost.localdomain> <49BAD165.5020503@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Mar 2009, Jeremy Fitzhardinge wrote:

> Linus Torvalds wrote:
> > Ingo Molnar (1):
> >       x86: work around Fedora-11 x86-32 kernel failures on Intel Atom CPUs
> >   
> 
> I don't see a change titled this either in tip.git or linux-2.6.git.  Did it
> get lost?

Commit 211b3d03c7400f48a781977a50104c9d12f4e229?

		Linus
