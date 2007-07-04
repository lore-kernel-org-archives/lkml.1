Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbXGDRsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbXGDRsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 13:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXGDRr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 13:47:59 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:60820 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbXGDRr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 13:47:58 -0400
Date: Wed, 4 Jul 2007 19:47:53 +0200
From: DervishD <lkml@dervishd.net>
To: Karel Zak <kzak@redhat.com>
Cc: List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Message-ID: <20070704174753.GC1939@DervishD>
Mail-Followup-To: Karel Zak <kzak@redhat.com>,
	List util-linux-ng <util-linux-ng@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070703221156.GY14825@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070703221156.GY14825@petra.dvoda.cz>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Karel :)

 * Karel Zak <kzak@redhat.com> dixit:
>  The package build system is now based on autotools. The build system
>  supports  separate CFLAGS and LDFLAGS for suid programs (SUID_CFLAGS,
>  SUID_LDFLAGS). For more details see the README file

    If you want to have configurable installation directories and
configurable settings for building but with the pain of autotools, you
can give "mobs" a try if you want. You will find in my homepage (see my
signature below). If you find it so much big and/or you think you will
be changing a pain for another pain, I can help porting.

    Anyway, if you don't like mobs or you just don't want to try it,
that's fine, but please don't use autotools, it doesn't make much sense
for a linux only project, since you will be using only the "directory
choosing" part of autotools. Maybe a hand made script will help (and I
can help with that, too) if you just want to have selectable directories
and CFLAGS support...

    And thanks for util-linux-ng, I was waiting for them :))

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
