Return-Path: <linux-kernel-owner+w=401wt.eu-S1763848AbXHOOUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763848AbXHOOUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758213AbXHOOUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:20:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:37661 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756347AbXHOOUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:20:07 -0400
X-Authenticated: #427522
X-Provags-ID: V01U2FsdGVkX1+rA38p7YCrkz5yuDabQ1gjk9FZTk3TMPwj+1EjDj
	Exe61Jiy0cBJpJ
Message-ID: <46C30C48.70905@gmx.de>
Date: Wed, 15 Aug 2007 16:23:04 +0200
From: Mathis Ahrens <Mathis.Ahrens@gmx.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070327)
MIME-Version: 1.0
To: Russ Dill <russ.dill@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Reporting result of pci=assign-busses to lkml
References: <f9d2a5e10708102011o7d61086fs9e2b35abca9b39a3@mail.gmail.com>
In-Reply-To: <f9d2a5e10708102011o7d61086fs9e2b35abca9b39a3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Russ,

in case you are still wondering about this...

There is a good explanation of the original reasoning here:
    http://lists.opensuse.org/opensuse-bugs/2007-02/msg00149.html

And there are plans to remove the message here
    http://www.uwsg.iu.edu/hypermail/linux/kernel/0707.3/2879.html

I am still seeing the warning in 2.6.23-rc3, but it makes no difference
if I specify pci=assign-busses ... everything seems fine either way.

Cheers,
Mathis
