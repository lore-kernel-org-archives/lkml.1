Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbXFPCTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbXFPCTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 22:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXFPCTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 22:19:18 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:36269 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277AbXFPCTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 22:19:17 -0400
Date: Fri, 15 Jun 2007 22:19:14 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Seth Arnold <seth.arnold@suse.de>
cc: Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
       Pavel Machek <pavel@ucw.cz>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070616001810.GP3564@suse.de>
Message-ID: <Line.LNX.4.64.0706152148170.29737@localhost.localdomain>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com>
 <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz>
 <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com>
 <20070615234925.GB15056@kroah.com> <20070616001810.GP3564@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Seth Arnold wrote:

> The time for restorecon is probably best imagined as a kind of 'du' that
> also updates extended attributes as it does its work. It'd be very
> difficult to improve on this.

restorecon can most definitely be improved. 


- James
-- 
James Morris
<jmorris@namei.org>
