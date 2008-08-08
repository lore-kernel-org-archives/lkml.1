Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbYHHGu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbYHHGu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYHHGuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:50:20 -0400
Received: from ozlabs.org ([203.10.76.45]:51559 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbYHHGuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:50:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: Spinlock recursion in hvc_poll
Date: Fri, 8 Aug 2008 16:50:16 +1000
User-Agent: KMail/1.9.9
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48973E59.1000904@citrix.com> <48996B0E.5000009@citrix.com> <200808070918.34220.borntraeger@de.ibm.com>
In-Reply-To: <200808070918.34220.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081650.16425.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 August 2008 17:18:34 Christian Borntraeger wrote:
> Am Mittwoch, 6. August 2008 schrieb Alex Nixon:
> > The patch appears to fix things.
>
> Rusty,
>
> can this patch go into 2.6.27-rc* via your queue?

Done, thanks.

Rusty.
