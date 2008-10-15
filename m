Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbYJOFag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbYJOFag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 01:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYJOFa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 01:30:28 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:35789 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbYJOFa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 01:30:28 -0400
Date: Wed, 15 Oct 2008 08:30:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Kaz Kylheku <kkylheku@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL question: using large contiguous memory in proprietary
	driver.
Message-ID: <20081015053026.GD20183@cs181140183.pp.htv.fi>
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com> <48F5193B.1010601@nortel.com> <3f43f78b0810141623s4282f9eof87014d2dee17810@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3f43f78b0810141623s4282f9eof87014d2dee17810@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 04:23:37PM -0700, Kaz Kylheku wrote:
> On Tue, Oct 14, 2008 at 3:12 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> > Kaz Kylheku wrote:
> >
> >> I have the following question. Suppose that some proprietary driver
> >> (otherwise completely clean, based only on non-GPL symbols)
> >
> > The fact that it's not using GPL symbols does not actually mean that the
> > driver is not a derivative work of the kernel (and thus subject to the GPL).
> 
> But thanks to the gracious tolerance of the kernel development
> community, such drivers are permitted to exist.
>...

"tolerance" = "it has not yet been brought to court"

There is no explicit permission of any kind for doing this, and it can 
be might to court in any country based on the local copyright law at
any time.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

