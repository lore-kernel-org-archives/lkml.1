Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZBKBOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZBKBOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZBKBOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:14:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:35874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbZBKBOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:14:10 -0500
Date: Tue, 10 Feb 2009 17:13:58 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 0/2] Make the touchpad on the MSI Wind netbook work
Message-ID: <20090210171358.78c34d41@infradead.org>
In-Reply-To: <alpine.LRH.1.10.0902110156390.22097@twin.jikos.cz>
References: <20090204191540.2d6abd87@infradead.org>
	<20090210202558.GH1382@ucw.cz>
	<200902102300.19065.rjw@sisk.pl>
	<alpine.LRH.1.10.0902110156390.22097@twin.jikos.cz>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 02:00:21 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 10 Feb 2009, Rafael J. Wysocki wrote:
> 
> > > Well, that beast was selling with linux preloaded, no? Or was it 
> > > another msi wind? In such case I'd expect old kernel to work...
> > > or maybe some reasonable workaround somewhere...
> > In fact I have an MSI Wind and the touchpad is works on it just
> > fine with the current mainline.
> > Perhaps this one is just another MSI Wind.  What model is it?
> 
> >From what I have heard there are different models of MSI Wind out
> >there, 
> with different set of hardware configurations.
> 
> Arjan, Rafael, could you please provide the dmidecode outputs for the 
> working and non-working systems, so that we can see what are the 
> differences?

does this matter for the patch ?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
