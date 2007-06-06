Return-Path: <linux-kernel-owner+w=401wt.eu-S1762688AbXFFKqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762688AbXFFKqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbXFFKqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:46:47 -0400
Received: from www.osadl.org ([213.239.205.134]:46833 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755630AbXFFKqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:46:46 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: John Sigler <linux.kernel@free.fr>
Subject: Re: PCI MPEG-2 encoder with SDI input in Linux 2.6
Date: Wed, 6 Jun 2007 12:46:07 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Video 4 Linux Mailing List <video4linux-list@redhat.com>
References: <46668F28.807@free.fr>
In-Reply-To: <46668F28.807@free.fr>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061246.07668.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,
the Video4Linux mailing list is a better place for this question.
I've added them to CC. Please remove linux-kernel from CC when
answering.

Thanks,
Hans

Am Mittwoch 06 Juni 2007 12:40 schrieb John Sigler:
> Hello,
> 
> I work for a small company involved in broadcast.
> 
> For the past year, we've been looking for a PCI board that meets
> at least the following requirements:
> 
> 1. Serial Digital Interface input
> http://en.wikipedia.org/wiki/Serial_Digital_Interface
> 
> 2. On-board (hardware) MPEG-2 encoder (our app runs on a low-spec PC) 
> which returns a smooth CBR Transport Stream
> http://en.wikipedia.org/wiki/Transport_stream
> 
> 3. Robust Linux 2.6 device driver
> 
> AFAIU, the major player in this space is Optibase's MovieMaker 230 
> Publisher. AFAICT, they only support 2.4 kernels, and the board is 
> overpriced.
> 
> I had hoped that Greg Kroah-Hartman's offer would change the landscape, 
> but I don't think it has.
> 
> At this point, I am definitely open to any and all comments, 
> suggestions, and ideas.
> 
> Regards.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
