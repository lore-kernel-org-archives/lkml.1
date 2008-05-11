Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYEKSHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYEKSHB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbYEKSGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:06:51 -0400
Received: from mx1.riseup.net ([204.13.164.18]:41671 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbYEKSGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:06:50 -0400
Date: Sun, 11 May 2008 20:06:43 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 0/2] HFS: Convert bitmap_lock and extents_lock in
	mutexes
Message-ID: <20080511180643.GA21359@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	zippel@linux-m68k.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20080511174331.584439618@kaehlcke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511174331.584439618@kaehlcke.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, May 11, 2008 at 07:43:31PM +0200 matthias@kaehlcke.net ha dit:

> Apple Macintosh file system: The semaphores bitmap_lock and extents_lock are used as mutexes. Convert them to the mutex API

sorry, i just realized that the patches use relative paths. i'm going
to submit a fix

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona


   Usually when people are sad, they don't do anything. They just cry over
     their condition. But when they get angry, they bring about a change
                              (Malcolm X)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
