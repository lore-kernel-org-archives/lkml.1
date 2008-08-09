Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYHILqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYHILqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 07:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYHILqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 07:46:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2309 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751338AbYHILql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 07:46:41 -0400
Date: Sat, 9 Aug 2008 13:09:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Len Brown <lenb@kernel.org>,
       Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [linux-pm] Linux Power Management Mini-Summit -- Ottawa -- July 22, 2008
Message-ID: <20080809110909.GA12539@ucw.cz>
References: <alpine.LFD.1.10.0807171724070.16742@localhost.localdomain> <20080718095000.GA5017@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718095000.GA5017@in.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-07-18 04:50:00, Gautham R Shenoy wrote:
> On Thu, Jul 17, 2008 at 05:27:32PM -0400, Len Brown wrote:
> > We'll be in The Rideau Suite in Les-Suites
> > Tuesday July 22nd 8:30-18:30.
> > 
> > Thanks to HP for sponsoring
> > lunch at 12:30 as well as snacks at 10:00 and 15:30.
> > We'll wing it for dinner.
> > 
> > On linux-pm (sorry, on sabbatical I've been
> > bad about keeping up on email) I've seen
> > intent to attend from:
> > 
> > Len Brown <len.brown@intel.com>
> > Alan Stern <stern@rowland.harvard.edu>
> > Dipankar Sarma <dipankar@in.ibm.com>
> > Rafael J. Wysocki <rjw@sisk.pl>
> > "Woodruff, Richard" <r-woodruff2@ti.com>
> > Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > Matt Domsch <Matt_Domsch@dell.com>
> > Jarod Wilson <jwilson@redhat.com>
> > Tim Bird <tim.bird@am.sony.com>
> > Paul Mundt <lethal@linux-sh.org>
> > Hiroyuki Machida <Hiroyuki.Mach@gmail.com>
> > 
> Hi Len,
> I would like to attend the pm-mini summit if there's a slot available. I
> am interested in discussing:
> 
> a) the improvements to idle load balancing
> algorithm on multi-node multi-core systems, for better power savings.
> 
> b) Use of some kind of light-weight CPU-Hotplug for power-management
> on server systems.

Step one, fix cpu hotplug not to eat more power than idle cpu...?

I wonder, how can cpu hotplug help, relative to inteligent scheduler?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
