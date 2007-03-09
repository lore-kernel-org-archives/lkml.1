Return-Path: <linux-kernel-owner+w=401wt.eu-S1767201AbXCILmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767201AbXCILmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767203AbXCILmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:42:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:26395 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767201AbXCILmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:42:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=lpdTK9iBKWO0AnToN/qlI0Hyj2YGQV76T4yFX9R9Hj6C5ko/FZYdmuo2hk4fHoqnhsIdCbr61UmZmwWLH8dERqmBOGA8VR/1PsgnUFQGKlOPM8AJlHaDOe+51D7G/1qvZbYVG+HymcpUgD0F49/qrEsEOCEy//zI/6t5YwIoRBc=
Date: Fri, 9 Mar 2007 11:40:43 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm1
Message-ID: <20070309114043.GE12727@slug>
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307201839.6f45735b.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 08:18:39PM -0800, Andrew Morton wrote:
> - The wireless changes in here need a lot of testers, please.  It is major
>   rework.
[...]
>   I was able to get ipw2200 working after some fumbling,
Any details on the symptoms? I'm unable to boot rc3-mm2, and it hangs
right after printing the ipw2200 driver message. I'll investigate that
this week-end.

Regards,
Frederik
