Return-Path: <linux-kernel-owner+w=401wt.eu-S1764498AbXGVUTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764498AbXGVUTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762635AbXGVUTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:19:37 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:12661 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762633AbXGVUTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:19:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MV553KuITOrQwWA4WaGUuFR5Y37q7X3ZkAtShy6GOqIYDoBIVaesPALp5DjA4cuOHLG3Jl8oWmyvWFaVXJfzH8rz9In3t0BzYOG3ek4qZBwnhd/uLVBQ6PkKnaIW5yndXhpd5HKlwJKrPBqFWYHrWPTlUEP6N41AwQy638veXSY=
Message-ID: <19061b0b0707221319q5311ce55p25e289cc452fe57@mail.gmail.com>
Date: Sun, 22 Jul 2007 21:19:34 +0100
From: Bartek <poemann@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Pata support for IDE Controller 82801G ICH7 in Linux 2.6.22
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <6bffcb0e0707221155l5bf7702r449846be48940a42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19061b0b0707220259h207f27d7wa836b1973c547e63@mail.gmail.com>
	 <6bffcb0e0707220311v5b145050hbd911e37b6f14c80@mail.gmail.com>
	 <19061b0b0707221021p4ca776d9k737121ddf553b1ce@mail.gmail.com>
	 <6bffcb0e0707221155l5bf7702r449846be48940a42@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/22, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>:
> Ok, this controller is supported.
>
> Did you forgot about CONFIG_PATA_MPIIX=y?

I did not mention it in my previous message, but I made a few
different compilation of Linux, also with that option (compiled
directly to the kernel and as a module). And it did not work. But, to
be sure I recompiled kernel again with CONFIG_PATA_MPIIX=y and it did
not work. So, if the controller is supported, where is the problem?

Bartek
