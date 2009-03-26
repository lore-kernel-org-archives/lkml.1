Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbZCZOdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbZCZOdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZCZOdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:33:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:53381 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742AbZCZOdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:33:11 -0400
Date: Thu, 26 Mar 2009 15:33:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: linux-next as a plain diff ?
In-Reply-To: <20090326100555.GA21835@elf.ucw.cz>
Message-ID: <alpine.LRH.2.00.0903261531000.8561@twin.jikos.cz>
References: <20090326100555.GA21835@elf.ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009, Pavel Machek wrote:

> Is there linux-next available somewhere as a plain diff? I'd like to 
> look at tomoyo changes... unfortunately that does not seem exactly easy. 
> I thought that maybe -mm could help, but... latest -mm listed on 
> kernel.org is for 2.6.28-rc2-mm1....

You could either extract it trivially directly form -next git repository, 
or get a (always little bit outdated) version from 
http://userweb.kernel.org/~akpm/mmotm/broken-out/linux-next.patch

-- 
Jiri Kosina
SUSE Labs

