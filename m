Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZDOVAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZDOVAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbZDOVA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:00:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52515 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbZDOVA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:00:26 -0400
Date: Wed, 15 Apr 2009 22:00:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       yakui_zhao <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness with hotkeys (BISECTED)
Message-ID: <20090415210017.GA32594@srcf.ucam.org>
References: <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com> <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com> <20090413203450.GC16152@khazad-dum.debian.net> <49E5234E.5070303@gmail.com> <20090415164939.GA27807@srcf.ucam.org> <49E63BCB.9090801@gmail.com> <20090415200125.GA31483@srcf.ucam.org> <49E64A28.8070402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E64A28.8070402@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 10:57:12PM +0200, Niel Lambrechts wrote:

> So is there any chance of getting this fix merged any time soon (at
> least before 2.6.30 is out)?

Yeah, I'd hope it's merged before .30. I've sent it to the maintainers.

> I'd love to use KMS, but I have no idea how to troubleshoot the freeze
> I'm getting after the main gdm login screen. Or is there still a future
> i915 milestone(s) to be reached before I can realistically do
> i915.modeset=1, given the large amount of activity around this in recent
> times?

There's still a lot of work being done in this area, and it can be a bit 
sensitive to you using the correct X driver version with a given kernel 
version.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
