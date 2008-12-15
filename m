Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbYLOLU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbYLOLU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYLOLUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:20:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbYLOLUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:20:49 -0500
Date: Mon, 15 Dec 2008 06:23:15 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/2] IOAPIC NMI watchdog fixes
Message-ID: <20081215112315.GA51028@redhat.com>
References: <20081027164233.132189000@napanee.usersys.redhat.com> <alpine.LFD.1.10.0810271651520.18692@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810271651520.18692@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > These two patches make use of __acpi_nmi_disable() to make possible to:
> > - enable and disable IOAPIC NMI watchdog using procfs
> > - disable NMI generation if the NMI watchdog is not working on boot time
> 
>  Thanks, I'll see if I can find some time soon to give them a hit -- I've 
> got a serial console on my laptop now, :) so any odd boot-time tests will 
> be easier for me.  These would be best tested with Ingo's APIC tree, a 
> current snapshot of which I may not have handy.  Ping me if I don't 
> respond within a few days.
ping :)

-- 
Aristeu

