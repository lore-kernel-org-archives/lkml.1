Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZEEOVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZEEOVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZEEOUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:20:53 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:41655 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZEEOUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:20:52 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 5 May 2009 07:16:20 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v4 0/2] irqfd
In-Reply-To: <20090504175657.26758.12503.stgit@dev.haskins.net>
Message-ID: <alpine.DEB.1.10.0905050713160.25206@makko.or.mcafeemobile.com>
References: <20090504175657.26758.12503.stgit@dev.haskins.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Gregory Haskins wrote:

> (Applies to kvm.git:7da2e3ba, plus you will also need Davide Libenzi's
> eventfd_file_create() patch, which you can find here:
> 
> http://www.mail-archive.com/kvm@vger.kernel.org/msg13923.html

Ping me back if Al acks the irqfd thing, that I'll take a better look at 
the patch above and make an official post. Without any users, I'd rather 
leave the current code as is.


- Davide


