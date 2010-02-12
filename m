Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0BLQoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:44:18 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41064 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab0BLQoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:44:17 -0500
Date: Fri, 12 Feb 2010 16:44:12 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: Julien BLACHE <jb@jblache.org>, nicolas@boichat.ch,
       felipe_alfaro@linuxmail.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Brightness control for MacBook Pro - Nvidia 9400
Message-ID: <20100212164412.GA21279@srcf.ucam.org>
References: <1265920725.7103.7.camel@no> <878wayk8hn.fsf@sonic.technologeek.org> <20100212141457.GA18714@srcf.ucam.org> <87zl3eto99.fsf@sonic.technologeek.org> <20100212162810.GA20998@srcf.ucam.org> <1265992937.3485.34.camel@no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265992937.3485.34.camel@no>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 05:42:17PM +0100, Soeren Sonnenburg wrote:
> On Fri, 2010-02-12 at 16:28 +0000, Matthew Garrett wrote:
> > On Fri, Feb 12, 2010 at 05:25:22PM +0100, Julien BLACHE wrote:
> > 
> > > Is it exposed to userspace in any way? Or, better yet, could we have an
> > > MBP backlight driver which would hide all of this from userspace?
> > 
> > Sure, in nouveau.
> 
> OK, great convinced. Any suggestions on where to add printk's to figure
> out the cause of the hang? The only thing I noticed was the fans turning
> on so the machine is either stuck in a busy loop or ???

Best bet is probably to file a bug on bugs.freedesktop.org - I'm afraid 
I'm not too hot on the GPU bringup side of the driver.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
