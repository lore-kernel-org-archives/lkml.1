Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbZFCRa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbZFCRa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbZFCRaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:30:19 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:46194 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbZFCRaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:30:17 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 3 Jun 2009 10:24:07 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: paulmck@linux.vnet.ibm.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, mst@redhat.com
Subject: Re: [KVM-RFC PATCH 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
In-Reply-To: <4A26B284.3060809@novell.com>
Message-ID: <alpine.DEB.1.10.0906031023470.18001@makko.or.mcafeemobile.com>
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602151538.29746.40356.stgit@dev.haskins.net> <20090602180256.GD6743@linux.vnet.ibm.com> <4A256E12.9060301@novell.com> <20090602220157.GF6743@linux.vnet.ibm.com> <4A25D799.10604@novell.com>
 <20090603150439.GB6640@linux.vnet.ibm.com> <4A26B284.3060809@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Gregory Haskins wrote:

> 
> Thanks again for the review, Paul.  IIUC, you think the design is ok as
> it is.
> 
> Davide,
>    In light of this, would you like to submit patch 1/2 formally with
> your SOB at your earliest convenience?  Or would you prefer that I
> submit it and you can simply ack it?  Either is fine with me.

Will do later today...



- Davide


