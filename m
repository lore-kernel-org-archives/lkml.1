Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYFORa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYFORa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbYFORaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 13:30:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53633 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758540AbYFORaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 13:30:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Newall <davidn@davidnewall.com>
Subject: Re: Regressions in the last kernels
Date: Sun, 15 Jun 2008 19:31:21 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: werner <werner@sys-linux.yi.org>, linux-kernel@vger.kernel.org
References: <1213467969.31034@sys-linux.yi.org> <200806151301.42469.rjw@sisk.pl> <48552C98.1020105@davidnewall.com>
In-Reply-To: <48552C98.1020105@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806151931.22224.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 15 of June 2008, David Newall wrote:
> Rafael J. Wysocki wrote:
> > On Sunday, 15 of June 2008, David Newall wrote:
> >   
> >> werner wrote:
> >>     
> >>> During preparation and own testing for my distro; installation on computers
> >>> for neighbours, by reclamations by users, I learned about the following
> >>> problems of 2.6.26-rcX :  
> >>>
> >>> 1) When compiling for i486,  one cannot select/configurate more memory than
> >>> 4 GB, menuconfig don't show items with higher values. 
> >>>   
> >>>       
> >> Is not the i486 limited to a 4GB address space?
> >>     
> >
> > The point, if I understand it correctly, is that if you compile the kernel for
> > i486 and then run it on something that does support PAE, it will only see
> > 4 GB of RAM.
> 
> Rather like compiling it for i486 and running it on ia64: you ask for an
> i486, you don't get to use features beyond that CPU.

Sure, that's reasonable.

Thanks,
Rafael
