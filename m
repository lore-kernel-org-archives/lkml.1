Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYJ2RF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYJ2RF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 13:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYJ2RFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 13:05:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42810 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYJ2RFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 13:05:47 -0400
Date: Wed, 29 Oct 2008 18:13:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Len Brown <len.brown@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, toshiba_acpi@memebeam.org,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org, preining@logic.at
Subject: Re: ACPI video.c brightness handler conflicts with toshiba_acpi
Message-ID: <20081029171346.GC7734@one.firstfloor.org>
References: <200809061108.34877.arvidjaar@mail.ru> <200810281615.19894.rjw@sisk.pl> <200810281922.20490.arvidjaar@mail.ru> <200810291654.56710.trenn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810291654.56710.trenn@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 04:54:54PM +0100, Thomas Renninger wrote:
> > So far I am running with these commits from
> > git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-2.6:
> This tree does not exist anymore...

It is now linux-acpi-summer2008-2.6
I renamed to avoid confusion with Len's tree.
But Len should have taken all the patches in there.

-Andi
