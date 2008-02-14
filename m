Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYBNPvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYBNPvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYBNPuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:50:55 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:42933 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752298AbYBNPuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:50:50 -0500
Date: Fri, 15 Feb 2008 00:49:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: first tree
Message-ID: <20080214154928.GC14777@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Len Brown <lenb@kernel.org>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au> <200802141545.56488.rjw@sisk.pl> <20080215020019.f7cb5895.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215020019.f7cb5895.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 02:00:19AM +1100, Stephen Rothwell wrote:
> Hi Rafael,
> 
> On Thu, 14 Feb 2008 15:45:55 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >
> > Perhaps you can add:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6 test
> 
> I would prefer that the trees be added by the subsystem maintainers and
> they can tell me which branch represents their expectations for the next
> kernel release (in this case 2.6.26). But thanks, hopefully you will have
> prodded them along. :-)
> 
For SH:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

This is also what goes in to -mm.
