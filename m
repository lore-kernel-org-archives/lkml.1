Return-Path: <linux-kernel-owner+w=401wt.eu-S1762479AbZFXUmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479AbZFXUmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZFXUmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:42:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759994AbZFXUmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:42:01 -0400
Date: Wed, 24 Jun 2009 13:41:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Build failure latest git. (acl related)
In-Reply-To: <20090624203815.GT8633@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.01.0906241340410.3154@localhost.localdomain>
References: <20090624200941.GA30531@phenom2.trippelsdorf.de> <20090624202852.GA31192@phenom2.trippelsdorf.de> <20090624203330.GS8633@ZenIV.linux.org.uk> <20090624203815.GT8633@ZenIV.linux.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Al Viro wrote:
> 
> Please, pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linux
> 
> Missing ifdef in posix_acl.h...

I assume that should be 'for-linus'.

			Linus
