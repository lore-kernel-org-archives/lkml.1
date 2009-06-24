Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbZFXUiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbZFXUiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759784AbZFXUiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:38:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57141 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176AbZFXUiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:38:13 -0400
Date: Wed, 24 Jun 2009 21:38:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build failure latest git. (acl related)
Message-ID: <20090624203815.GT8633@ZenIV.linux.org.uk>
References: <20090624200941.GA30531@phenom2.trippelsdorf.de> <20090624202852.GA31192@phenom2.trippelsdorf.de> <20090624203330.GS8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624203330.GS8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 09:33:30PM +0100, Al Viro wrote:
> On Wed, Jun 24, 2009 at 10:28:52PM +0200, Markus Trippelsdorf wrote:
> > 
> > This patch should fix it:
> 
> Applied.

Please, pull from

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linux

Missing ifdef in posix_acl.h...
