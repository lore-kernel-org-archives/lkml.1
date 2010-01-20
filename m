Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652Ab0ATRTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0ATRTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580Ab0ATRT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:19:28 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42298 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab0ATRT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:19:26 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 20 Jan 2010 09:19:19 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Avi Kivity <avi@redhat.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, mtosatti@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] kvm: fix spurious interrupt with irqfd
In-Reply-To: <4B570EDD.6000808@redhat.com>
Message-ID: <alpine.DEB.2.00.1001200918280.29304@makko.or.mcafeemobile.com>
References: <20100113171222.GA19798@redhat.com> <4B5305CA.5070001@redhat.com> <20100119145202.GC28465@redhat.com> <4B570EDD.6000808@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Avi Kivity wrote:

> I'm uncomfortable with pushing Davide's patch into stable and possibly causing
> regressions with unrelated applications.  Can't a guest live with a spurious
> interrupt?  It's not like they're unknown.

Better material for .33 instead of stable, I agree.


- Davide


