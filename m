Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZBKBB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZBKBB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZBKBBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:01:18 -0500
Received: from twin.jikos.cz ([213.151.79.26]:56101 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbZBKBBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:01:17 -0500
Date: Wed, 11 Feb 2009 02:00:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@suse.cz>, Arjan van de Ven <arjan@infradead.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 0/2] Make the touchpad on the MSI Wind netbook work
In-Reply-To: <200902102300.19065.rjw@sisk.pl>
Message-ID: <alpine.LRH.1.10.0902110156390.22097@twin.jikos.cz>
References: <20090204191540.2d6abd87@infradead.org> <20090210202558.GH1382@ucw.cz> <200902102300.19065.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009, Rafael J. Wysocki wrote:

> > Well, that beast was selling with linux preloaded, no? Or was it 
> > another msi wind? In such case I'd expect old kernel to work... or 
> > maybe some reasonable workaround somewhere...
> In fact I have an MSI Wind and the touchpad is works on it just fine with the
> current mainline.
> Perhaps this one is just another MSI Wind.  What model is it?

>From what I have heard there are different models of MSI Wind out there, 
with different set of hardware configurations.

Arjan, Rafael, could you please provide the dmidecode outputs for the 
working and non-working systems, so that we can see what are the 
differences?

Thanks,

-- 
Jiri Kosina
SUSE Labs

