Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbZCXLEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbZCXLEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZCXLEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:04:40 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:52742 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbZCXLEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o8iHdf5bw6ja6AaJZ98XmqCXlm9d43bis4NdV+VZuhxD8qXhwSOzo3F8UPHbNyHODE
         4xfgOwtYjogFsGwHh7SNDG6tNtzuCi75sA41icrYxXNzgp24bKNPfZS3HJMWUs5pVH4Z
         AUv0FsfEY8Q0bTDHILYQXe3+YzNycOA3B1ypY=
Date: Tue, 24 Mar 2009 12:04:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
Subject: Re: [Announce] 2.6.29-rc8-rt3
Message-ID: <20090324110431.GA6058@nowhere>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain> <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain> <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain> <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain> <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain> <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain> <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 05:26:52PM +0100, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
> 
>     - fix a x86 32bit PAE pagetable corruption caused by a hard to
>       trigger race.
> 
>     - update to latest linus and tip
> 
> Download locations:
> 
>     http://rt.et.redhat.com/download/
>     http://www.kernel.org/pub/linux/kernel/projects/rt/
>  
> Information on the RT patch can be found at:
> 
>     http://rt.wiki.kernel.org/index.php/Main_Page
> 
> to build the 2.6.29-rc8-rt3 tree, the following patches should be
> applied:
> 
>     http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc8.tar.bz2
>     http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc8-rt3.bz2


Hi,

It doesn't seem to be available (404).
But I can see a 2.6.29-rc8-rt4.bz2 downloadable.

Thanks.
 

> The broken out patches are also available at the same download
> locations.
> 
> Enjoy !
> 
>        tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

