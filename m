Return-Path: <linux-kernel-owner+w=401wt.eu-S1751142AbZH0RJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbZH0RJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZH0RJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:09:05 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51601 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZH0RJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:09:04 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Aug 2009 10:09:00 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Paolo Bonzini <pbonzini@redhat.com>, Avi Kivity <avi@redhat.com>,
       gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
In-Reply-To: <alpine.DEB.2.00.0908270752090.3809@makko.or.mcafeemobile.com>
Message-ID: <alpine.DEB.2.00.0908271007450.5649@makko.or.mcafeemobile.com>
References: <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com> <1251363930-3916-1-git-send-email-pbonzini@redhat.com> <alpine.DEB.2.00.0908270720250.3809@makko.or.mcafeemobile.com> <20090827143027.GA22720@redhat.com>
 <alpine.DEB.2.00.0908270732470.3809@makko.or.mcafeemobile.com> <20090827144905.GA22728@redhat.com> <alpine.DEB.2.00.0908270752090.3809@makko.or.mcafeemobile.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Michael S. Tsirkin wrote:

> Oh, I stopped pushing EFD_STATE since we have a solution.

Do you guys need the kernel-side eventfd_ctx_read() I posted or not?
Because if nobody uses it, I'm not going to push it.


- Davide


