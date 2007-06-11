Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbXFKQhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbXFKQhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbXFKQg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:36:59 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:62698 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbXFKQg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:36:58 -0400
Date: Mon, 11 Jun 2007 19:36:11 +0200
From: DervishD <lkml@dervishd.net>
To: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext2 on flash memory
Message-ID: <20070611173611.GA2433@DervishD>
Mail-Followup-To: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>,
	linux-kernel@vger.kernel.org
References: <20070611101319.GA14284@DervishD> <466D2DF7.9020709@aladin.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <466D2DF7.9020709@aladin.ro>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Eduard :)

 * Eduard-Gabriel Munteanu <maxdamage@aladin.ro> dixit:
> >    I was wondering: is there any reason not to use ext2 on an USB
> >pendrive? Really my question is not only about USB pendrives, but any
> >device whose storage is flash based. Let's assume that the device has
> >a good quality flash memory with wear leveling and the like...
> 
> Your USB pendrive will wear faster if you use an inappropriate
> filesystem. Such filesystems require frequent writes and change their
> internal state often.

    That's what I supposed.

> Really, why don't you try a more suitable fs for your pendrive, one that 
> changes itself less than usual fs's?

    I was just wondering if, apart from the excessive wear, there were
other reasons. One of the reasons I would like to use a good filesystem
for a pendrive is to be able to store file metadata (UID, GID, mode,
etc.) properly, for example to store a "live" copy of my home dir in the
pendrive.

    Thanks for your answer :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
