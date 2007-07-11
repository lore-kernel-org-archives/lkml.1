Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbXGKHr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbXGKHr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760522AbXGKHrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:47:17 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:24595 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760441AbXGKHrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i3JJRx5mUCDxkooPZ1siIOyBu9OuF6kXjdw9vjuvK3ZX2xCFZqNXQei28szDZbKOI/PxmDo4cB1DDF/LeaXNidmsWBodcOc1DOL54eo8Afv+uFDaFaVI3fJxFYhocGBpt23FXBDRT9dmS9MTQCdZKkSTmu0VJVvrkG2u5F7Lluk=
Message-ID: <a781481a0707110047md5027a1r56a18022147122d6@mail.gmail.com>
Date: Wed, 11 Jul 2007 13:17:15 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [PATCH 17/20] SMP: Implement on_cpu()
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       KVM <kvm-devel@lists.sourceforge.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <46948626.6050308@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11838956891287-git-send-email-avi@qumranet.com>
	 <20070709071640.GB10864@one.firstfloor.org>
	 <46920270.3080309@qumranet.com> <46921BE9.4040801@qumranet.com>
	 <a781481a0707091224s3fb1a2acr6d3ccce091480f61@mail.gmail.com>
	 <4693211D.4040406@qumranet.com>
	 <a781481a0707100222k4f204ed8gfd4823bc21b7bf25@mail.gmail.com>
	 <46936766.20900@qumranet.com>
	 <a781481a0707101707w121da1b7hc82dc0e3638e4570@mail.gmail.com>
	 <46948626.6050308@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/07, Avi Kivity <avi@qumranet.com> wrote:
> [...]
>
> It's not proposed.  Andi mentioned it in passing.

Ok, thanks for clarifying that.
