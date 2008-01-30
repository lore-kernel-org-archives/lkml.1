Return-Path: <linux-kernel-owner+w=401wt.eu-S1763281AbYA3Ryc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763281AbYA3Ryc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbYA3RyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:54:14 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57171 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512AbYA3RyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:54:13 -0500
Date: Wed, 30 Jan 2008 19:54:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Giridhar Pemmasani <pgiri@yahoo.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-kernel@vger.kernel.org,
       Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>, rms@gnu.org
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080130175447.GB29368@does.not.exist>
References: <20080129225701.GS8767@does.not.exist> <754585.89171.qm@web32403.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <754585.89171.qm@web32403.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 04:48:10PM -0800, Giridhar Pemmasani wrote:
> --- Adrian Bunk <bunk@kernel.org> wrote:
> 
> > It is interesting that someone posting with an @gnu.org address claims
> > that dynamic linking of not GPLv2 compatible code into GPLv2 code was
> > not a copyright violation.
> 
> There is no copyright violation: ndiswrapper is licensed under GPLv2. And the
> Windows driver is not linked to kernel code - only ndiswrapper functions are
> linked to kernel.
>...

IANAL, but I have serious doubts whether putting some glue layer between 
the GPL'ed code and the code with a not GPL compatible licence is really 
a legally effictive way of circumventing the GPL.

> Giri

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

