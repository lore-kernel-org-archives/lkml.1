Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbXBJKSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbXBJKSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 05:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbXBJKSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 05:18:08 -0500
Received: from ns9.hostinglmi.net ([213.194.149.146]:42049 "EHLO
	ns9.hostinglmi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbXBJKSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 05:18:07 -0500
X-Greylist: delayed 70073 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Feb 2007 05:18:06 EST
Date: Fri, 9 Feb 2007 15:51:22 +0100
From: DervishD <lkml@dervishd.net>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: introducing conditional submenus in the config process?
Message-ID: <20070209145122.GA11820@DervishD>
Mail-Followup-To: "Robert P. J. Day" <rpjday@mindspring.com>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702090901500.5499@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0702090901500.5499@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ns9.hostinglmi.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - dervishd.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Robert :)

 * Robert P. J. Day <rpjday@mindspring.com> dixit:
> 
>   i brought this up a while back but nothing was finalized -- is there
>   sufficient value in being able to select or deselect entire submenus
>   of features without having to descend into that submenu first?

    Not that my opinion counts at all, but IMHO this is a VERY good
idea. OK, the kernel configuration system is not for the faint of heart
anyway, but doing it a bit more user-friendly is a good idea.

    Apart for user-friendlyness, which in itself is a good point, the
most important thing here is speed. Normally I have a base .config and I
work by adding/removing a couple of features, but being able to
deselect/select full submenus in just one checkbox is faster (and IMHO
less error prone, specially when your fingers fly across the keyboard)
than having to descend.

    Moreover, it adds a bit more of structure to the kernel
configuration. The first time it can be scary...

    So, I vote for that, even if my opinion doesn't count and I don't
have a vote. For me looks like a very good idea.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
