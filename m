Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYFWDEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYFWDEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYFWDEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:04:15 -0400
Received: from ozlabs.org ([203.10.76.45]:42281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbYFWDEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:04:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [RFC 3/3 v2] s390: use virtio_console for KVM on s390
Date: Mon, 23 Jun 2008 13:04:00 +1000
User-Agent: KMail/1.9.9
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <200806031444.21945.borntraeger@de.ibm.com> <200806201524.18953.borntraeger@de.ibm.com>
In-Reply-To: <200806201524.18953.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231304.01109.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 June 2008 23:24:18 Christian Borntraeger wrote:
> This patch enables virtio_console as the default console on kvm for
> s390. We currently use the same notify hack as lguest for early
> console output. I will try to address this for lguest and s390 later.
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Thanks, applied all three.

Cheers,
Rusty.
