Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYI0TCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYI0TCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYI0TCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:02:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:25244 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbYI0TCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:02:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OReXi8xT6ZBPe68N5RSNbN9ZMMkTRPMvPRugLJrglzDfgsvBFBGbnB+oCwQ+JL0G0r
         KXGbbZtCKY1h63R/L0Eg6/2iNuP5XNtisDihnKWfEs9zYE0OTYPsr/amXZtXrRu8Y8+x
         AMSmLGa9JrgU+G3Mp+J450WdalnhIMogdlgaU=
Date: Sat, 27 Sep 2008 23:02:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Message-ID: <20080927190237.GD10186@localhost>
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com> <200809250900.24736.bjorn.helgaas@hp.com> <86802c440809251007n71738552n88b8ebfc7ecd017f@mail.gmail.com> <200809251152.23021.bjorn.helgaas@hp.com> <20080927185306.GA18619@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080927185306.GA18619@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sat, Sep 27, 2008 at 08:53:06PM +0200]
|
...

A bit offtopic...well...completely offtopic I would say :)

Ingo maybe you have any PCI specs? I've asked several people
for this. Peter adviced to ask HW vendors but I don't have
friends who has access to a such docs. Evgeniy Polyakov
promised to ask someone but I think there will not be success
too :(. I'll ask Maciej too later since now he seems to be
quite busy.
 
		- Cyrill -
