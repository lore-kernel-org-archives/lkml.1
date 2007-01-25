Return-Path: <linux-kernel-owner+w=401wt.eu-S1030569AbXAYVGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030569AbXAYVGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030570AbXAYVGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:06:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030569AbXAYVGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:06:51 -0500
X-Greylist: delayed 866 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 16:06:51 EST
Message-ID: <45B91894.3040604@redhat.com>
Date: Thu, 25 Jan 2007 15:52:36 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Stefan Priebe - FH <studium@profihost.com>
CC: linux-kernel@vger.kernel.org, edmudama@gmail.com
Subject: Re: XFS or Kernel Problem / Bug
References: <20060801141545.B2326184@wobbly.melbourne.sgi.com> <44CED76B.20507@profihost.com> <20060801142755.C2326184@wobbly.melbourne.sgi.com> <44CED8F4.9080208@profihost.com> <20060801143212.D2326184@wobbly.melbourne.sgi.com> <44CEDA1D.5060607@profihost.com> <20060801143803.E2326184@wobbly.melbourne.sgi.com> <44CF36FB.6070606@profihost.com> <20060802090915.C2344877@wobbly.melbourne.sgi.com> <44D07AB7.3020409@profihost.com> <20060802201805.A2360409@wobbly.melbourne.sgi.com> <45B35CD7.4080801@profihost.com> <45B666BE.8000802@redhat.com> <45B70D69.20500@profihost.com> <45B773C1.7090805@redhat.com> <45B77547.4060302@profihost.com> <45B77780.5000504@redhat.com> <45B77C84.6070508@profihost.com> <45B78E9F.4000404@redhat.com> <45B7948B.70104@profihost.com> <45B79DCF.4040904@redhat.com> <45B7B334.2050904@profihost.com>
In-Reply-To: <45B7B334.2050904@profihost.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Priebe - FH wrote:
> > What is different about these servers?
> All 300 machines are mostly different. We have Dual Opteron, single P4
> with HT, single P4 without HT, Dual Xeon, Athlon 64 X2, and many
> more... different mainboards etc.
>
> The only thing i found out is, that all these servers (where the
> problem exist) are using a DFI PM-12 Mainboard with a VIA Chipset.
Any others with VIA chipsets?
>
> > Are you building different kernels for them, or is it just different
> > drivers loaded?
> No every machine builds it's own kernel.
>
OK, can you post configs for one that works and one that doesn't?

And which C compiler(s) do you use? The same for all, I hope...

