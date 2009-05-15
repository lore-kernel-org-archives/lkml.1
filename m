Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZEOIVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZEOIVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZEOIVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:21:23 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:47876 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754483AbZEOIVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:21:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Xbxc5BT4WcFfrMOZRjGeHPw3NTumij6KqJRih+63Ugy75P0/P9KqsAnaqRXVDz3DXhbT18f/1JHpfxrCmAo7AomwRzKXuvtxTZKE8GhY8S0kyDnNIN0plI3Uz6DALT+EAOsEjSd3/35IE3LvbJ51+II1K6Z0pjLXGhYGVc2BPIk=  ;
X-YMail-OSG: h7FmOrEVM1nLis612VW7PDdJqh7dt_9NvkGIUkCkv3hMbGu5.CCobAQWksBIiuqcooqm8_HqtRN82u9HZfYh.94n2KM1dng1DPR7ncpXZlqhpnAko9UH0gFbhOYeslP7fez2WHhAbu1cewFIICAX1rxRpCfhMa_0M_L1E3AuA3pF1EloDKOBcp8vrDwB3TMApVSAm7NxYr7YIlVk7l2XKt.bPON7EnyrDplxKsgKHnZcOc7JrnhwF6kFIG9acduLflprp5eyad.cYE3YMVnRHics_bcM6qfd.4g9c25PPz6kScY.IlTe.sK0nZpEanC_UFjaQSqvqINjCqKOdUU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 0/3] DaVinci ASoC updates
Date: Fri, 15 May 2009 01:21:16 -0700
User-Agent: KMail/1.9.10
Cc: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
       lkml <linux-kernel@vger.kernel.org>,
       DaVinci <davinci-linux-open-source@linux.davincidsp.com>
References: <200905141235.35600.david-b@pacbell.net> <s5hy6sy23ba.wl%tiwai@suse.de>
In-Reply-To: <s5hy6sy23ba.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905150121.16736.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 May 2009, Takashi Iwai wrote:
> At Thu, 14 May 2009 12:35:35 -0700,
> David Brownell wrote:
> > 
> > The 2.6.30-rc5 merges included a bunch of DaVinci platform
> > updates, including EDMA support.  Which means that finally
> > the ASoC stuff can be made to build in mainline ... it was
> > probably sent to mainline before its time.  ;)
> > 
> > Following are three patches which resync mainline ASoC code
> > with what's in the DaVinci tree.  I'd like to suggest they
> > all merge before 2.6.30-final ... two are build fixes, and
> > the third is needed to make it work.
> 
> The patches haven't been sent yet?

I just cc'd Mark and Liam, maintainers of the ASoC stuff,
and the DaVinci list ... 

  http://linux.omap.com/pipermail/davinci-linux-open-source/2009-May/013339.html
  http://linux.omap.com/pipermail/davinci-linux-open-source/2009-May/013338.html
  http://linux.omap.com/pipermail/davinci-linux-open-source/2009-May/013340.html

If you want to merge them I'll forward those to you.

