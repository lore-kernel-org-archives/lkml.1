Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZDTAvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZDTAvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 20:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZDTAvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 20:51:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48382 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbZDTAvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 20:51:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] PM/Suspend: Introduce two new platform callbacks to avoid breakage (Re: 900af0d breaks some embedded suspend/resume)
Date: Mon, 20 Apr 2009 02:50:49 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <alpine.LFD.2.00.0904191357280.12867@localhost.localdomain> <20090419200330.GA16002@flint.arm.linux.org.uk>
In-Reply-To: <20090419200330.GA16002@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904200250.50476.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 April 2009, Russell King wrote:
> On Sun, Apr 19, 2009 at 01:57:44PM -0400, Len Brown wrote:
> > Acked-by: Len Brown <len.brown@intel.com>
> 
> Thanks.  Since there's no objections yet, can we get this merged?

I'm going to send a pull request in a minute.

Rafael
