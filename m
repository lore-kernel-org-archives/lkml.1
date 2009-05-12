Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbZELHAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbZELHAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZELHAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:00:41 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:57537 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZELHAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:00:40 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 11 May 2009 23:55:36 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: viro@ZenIV.linux.org.uk, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
In-Reply-To: <4A08F330.6070006@novell.com>
Message-ID: <alpine.DEB.1.10.0905112355160.26755@makko.or.mcafeemobile.com>
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com>
 <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com> <4A024214.9090002@novell.com> <alpine.DEB.1.10.0905080805510.16601@makko.or.mcafeemobile.com> <4A08F330.6070006@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> > On Wed, 6 May 2009, Gregory Haskins wrote:
> >
> >   
> >> If there isn't any more feedback on the series from Al, Avi,
> >> etc...please formally submit your eventfd patch so this series is
> >> available for Avi to pull in for inclusion when/if he deems it fit.
> >>     
> >
> > Did you decide you will be using those bits?
> >   
> 
> Hi Davide,
>   It appears that we will not end up needing them since the new version
> I am about to push goes back to creating the eventfd in userspace to
> begin with, per Avi's request.

That looks like a good idea.


- Davide


