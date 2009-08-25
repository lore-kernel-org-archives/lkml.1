Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbZHYV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbZHYV5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbZHYV5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:57:00 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59580 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZHYV47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:56:59 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 25 Aug 2009 14:57:01 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
In-Reply-To: <20090825072229.GA10608@redhat.com>
Message-ID: <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com>
References: <20090820175540.GA9232@redhat.com> <4A8D90BB.2030506@redhat.com> <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com>
 <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com> <20090824214900.GA9899@redhat.com> <alpine.DEB.2.00.0908241508440.7951@makko.or.mcafeemobile.com> <20090825072229.GA10608@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, Michael S. Tsirkin wrote:

> Yes, we don't want that. The best thing is to try to restate the problem
> in a way that is generic, and then either solve or best use existing
> solution. Right?
> 
> I thought I had that, but apparently not.  The reason I'm Cc-ing you is
> not to try and spam you until you give up and accept the patch, it's
> hoping that you see the pattern behind our usage, and help generalize
> it.
> 
> If I understand it correctly, you believe this is not possible and so
> any solution will have to be in KVM? Or maybe I didn't state the problem
> clearly enough and should restate it?

Please do.



- Davide


