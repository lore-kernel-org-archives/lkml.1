Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZEURcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZEURcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 13:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbZEURcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 13:32:16 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:35766 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbZEURcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 13:32:15 -0400
Subject: Re: 2.6.29+ NFS-Server Problem "reconnect_path: npd != pd"
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <20090521165751.GA4428@geggus.net>
References: <20090521142026.GA5566@geggus.net>
	 <1242924599.6687.1.camel@heimdal.trondhjem.org>
	 <20090521165751.GA4428@geggus.net>
Content-Type: text/plain
Date: Thu, 21 May 2009 13:32:13 -0400
Message-Id: <1242927133.6687.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 4 sum msgs/h 1 total rcpts 395 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=_URIID_)
X-UiO-Scanned: 5C1C3E665E731C0E27314EFACF750BF71EAA2C4E
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 299 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 18:57 +0200, Sven Geggus wrote:
> Trond Myklebust schrieb am Donnerstag, den 21. Mai um 18:49 Uhr:
> 
> > I can't find any such error message in the kernel.
> 
> The message seems to come from fs/exportfs/expfs.c
> 
> > Is this the userland NFS server?
> 
> No, its not!
> 
> Sven

So what is the underlying filesystem that you are exporting, and what
does your /etc/exports file look like?

Trond

