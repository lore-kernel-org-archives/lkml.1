Return-Path: <linux-kernel-owner+w=401wt.eu-S1761791AbYBOVGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761791AbYBOVGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759143AbYBOVFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:05:11 -0500
Received: from ns2.suse.de ([195.135.220.15]:55780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757808AbYBOVFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:05:08 -0500
Date: Fri, 15 Feb 2008 12:58:44 -0800
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Message-ID: <20080215205844.GC7583@suse.de>
References: <200802111623.38478.elendil@planet.nl> <200802122139.14840.elendil@planet.nl> <20080212205622.GA21986@suse.de> <200802131239.14305.elendil@planet.nl> <20080213165837.GA10129@suse.de> <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com> <20080215065230.GA8625@suse.de> <86802c440802150041x3a9f3e61na12cd1661696ec5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802150041x3a9f3e61na12cd1661696ec5e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 12:41:43AM -0800, Yinghai Lu wrote:
> On Thu, Feb 14, 2008 at 10:52 PM, Greg KH <gregkh@suse.de> wrote:
> >
> >  Ugh, sorry, I was mistaken, it's not a cpufreq issue, it's a
> >  CONFIG_DETECT_SOFTLOCKUP issue.  Or that is what I was told before.
> >
> 
> could  be two issues:
> one in cpufreq, and one in detect softlockup...

Looks like it's that way :)
