Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbYJaLzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbYJaLzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYJaLz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:55:28 -0400
Received: from twin.jikos.cz ([213.151.79.26]:40606 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYJaLz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:55:27 -0400
Date: Fri, 31 Oct 2008 12:55:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jeroen Roovers <jer@gentoo.org>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: 2.6.28-rc2: USB/INPUT: slab error in cache_alloc_debugcheck_after():
 double free?
In-Reply-To: <20081031044553.50882e86@epia.jer-c2.orkz.net>
Message-ID: <alpine.LRH.1.10.0810311254400.7585@twin.jikos.cz>
References: <200810310011.08618.deller@gmx.de> <20081031044553.50882e86@epia.jer-c2.orkz.net>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Jeroen Roovers wrote:

> I am seeing the same USB problem but without the SLAB errors - [1] is
> the Gentoo bug report. The kernel boots fine with both USB keyboard and
> mouse detached.

Could you please provide your config? I am still not able to reproduce it 
here. Thanks.

-- 
Jiri Kosina
SUSE Labs

