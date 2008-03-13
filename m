Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYCMOr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYCMOr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYCMOrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:47:51 -0400
Received: from the.earth.li ([217.147.81.2]:33298 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbYCMOrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:47:51 -0400
Date: Thu, 13 Mar 2008 14:47:50 +0000
From: Jonathan McDowell <noodles@earth.li>
To: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc5
Message-ID: <20080313144750.GA31684@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In article <20080313125541.GA7365@v2.random> (earth.lists.linux-kernel)
you wrote:
> On Thu, Mar 13, 2008 at 02:51:45PM +0800, Zhang, Rui wrote:
> > Well, the patch looks good, this may be caused by a BIOS problem.
> > anyway, I wish to get the response from Andrea so that I can do some
> > investigation ASAP.

> Here attached again. syslog isn't available because by the time it
> crash netconsole isn't up yet, but I try to compile it as module and
> see if it crashes by loading it manually later after netconsole
> started. (you didn't ask for syslog until today)

> Hardware is ASUS M2A-VM ACPI BIOS Revision 1604.

That's the same hardware I was hitting that
c8d16e27a3601d1cbcdfe657eb4ff5e762019e8d fixes.

J.

-- 
                                            jid: noodles@jabber.earth.li
101 things you can't have too much of : 2
                                            - Gaffa tape.
