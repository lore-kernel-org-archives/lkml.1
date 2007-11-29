Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbXK2Uac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbXK2Uac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbXK2UaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:30:20 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38774 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756222AbXK2UaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:30:19 -0500
Date: Thu, 29 Nov 2007 21:30:09 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tomas Carnecky <tom@dbservice.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH?] OSS: fix operator precedence in return of
	btaudio_dsp_ioctl
Message-ID: <20071129203009.GJ29463@stusta.de>
References: <474F02B2.6010406@tiscali.nl> <474F0C0E.8000109@dbservice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <474F0C0E.8000109@dbservice.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 07:59:26PM +0100, Tomas Carnecky wrote:
> Roel Kluin wrote:
> > First of all, is /sound/oss/* still maintained?
> > 
> 
> Documentation/feature-removal-schedule.txt
> 
> What:  drivers depending on OSS_OBSOLETE
> When:  options in 2.6.23, code in 2.6.25
> Why:   obsolete OSS drivers
> Who:   Adrian Bunk <bunk@stusta.de>

I'm maintaining only the gradual removal.  ;-)

That's only the removal of some of the remaining OSS drivers, but 
btaudio is among them.

> tom

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

