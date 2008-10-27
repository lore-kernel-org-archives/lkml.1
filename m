Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbYJ0Q7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbYJ0Q7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYJ0Q64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:58:56 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:45193 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYJ0Q64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:58:56 -0400
Date: Mon, 27 Oct 2008 16:58:50 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Aristeu Rozanski <aris@redhat.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/2] IOAPIC NMI watchdog fixes
In-Reply-To: <20081027164233.132189000@napanee.usersys.redhat.com>
Message-ID: <alpine.LFD.1.10.0810271651520.18692@ftp.linux-mips.org>
References: <20081027164233.132189000@napanee.usersys.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Aristeu Rozanski wrote:

> These two patches make use of __acpi_nmi_disable() to make possible to:
> - enable and disable IOAPIC NMI watchdog using procfs
> - disable NMI generation if the NMI watchdog is not working on boot time

 Thanks, I'll see if I can find some time soon to give them a hit -- I've 
got a serial console on my laptop now, :) so any odd boot-time tests will 
be easier for me.  These would be best tested with Ingo's APIC tree, a 
current snapshot of which I may not have handy.  Ping me if I don't 
respond within a few days.

  Maciej
