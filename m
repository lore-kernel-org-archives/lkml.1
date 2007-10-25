Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbXJYOOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbXJYOOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbXJYONu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:13:50 -0400
Received: from ns.suse.de ([195.135.220.2]:42352 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760157AbXJYONt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:13:49 -0400
Subject: Re: [Fwd: [PATCH 3/5] Export acpi_check_resource_conflict]
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <20071025154833.0240b8a2@hyperion.delvare>
References: <1193236387.4590.230.camel@queen.suse.de>
	 <20071024205347.6948c081.akpm@linux-foundation.org>
	 <20071025154833.0240b8a2@hyperion.delvare>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 25 Oct 2007 16:13:47 +0200
Message-Id: <1193321627.4590.278.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 15:48 +0200, Jean Delvare wrote:
> Hi Andrew,
> 
> On Wed, 24 Oct 2007 20:53:47 -0700, Andrew Morton wrote:
> > On Wed, 24 Oct 2007 16:33:07 +0200 Thomas Renninger <trenn@suse.de> wrote:
> > 
> > > From: Thomas Renninger <trenn@suse.de>
> > > To: linux-acpi <linux-acpi@vger.kernel.org>
> > > Cc: linux-kernel <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jean Delvare <khali@linux-fr.org>
> > > Reply-To: trenn@suse.de
> > > Subject: [Fwd: [PATCH 3/5] Export acpi_check_resource_conflict]
> > > Date: Wed, 24 Oct 2007 16:33:07 +0200
> > > Organization: Novell/SUSE
> > > X-Mailer: Evolution 2.8.2 
> > > 
> > > Export acpi_check_resource_conflict(), sometimes drivers already have
> > > a struct resource at hand so no need to use the wrappers to build a new
> > > one.
> > > 
> > > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > > ---
> > 
> > The attributions on this are all mucked up.
> > 
> > I _think_ it was written by Jean, in which case the changlog should
> > have had From:him right at the start to indicate this.  And as you
> > were in the delivery path, it should have had your signoff.
> > 
> > I'll make those changes - please let me know if I misguessed.
> 
> You are correct, patches 3/5, 4/5 and 5/5 of this patchset were written
> by me (as in: I'm the one to blame if something breaks). I expected
> Thomas to add a From: header and add his own Signed-off-by line but
> instead he forwarded my mails directly. Thanks for fixing up the mess,
> we'll try to make it better next time.

As said, I wasn't sure against what I should base all this.
I would had cleaned it up, depending on what you told me. I also didn't
know about the From: tag if you send patches not from your own, the next
time...
Anyways, it's nice to see how things can move on right away without much
delay and discussion.

Thanks,

   Thomas

