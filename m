Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbXDQNx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbXDQNx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbXDQNx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:53:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51426 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754361AbXDQNx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:53:28 -0400
Date: Tue, 17 Apr 2007 14:56:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Drift@tihlde" <drift@tihlde.org>
Cc: espen@oxygen.tihlde.org, linux-kernel@vger.kernel.org
Subject: Re: Machine Check Exception on Opteron 265
Message-ID: <20070417145618.624430d9@the-village.bc.nu>
In-Reply-To: <4620EC23.4010404@mrfjo.org>
References: <4620EC23.4010404@mrfjo.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2007 16:58:43 +0200
Espen Fjellvær Olsen <espen@oxygen.tihlde.org> wrote:

> Hi!
> Today our Opteron 265, 2x2, paniced after many months uptime, giving
> only this error message:
> 
> HARDWARE ERROR
> CPU 2: Machine Check Exception:            4 Bank 4: b60a200100000813
> TSC 6bb9fd0142921a ADDR a891e9b8
> This is not a software problem!
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^]

This is there for a good reason.

> We updated glibc yesterday, but that shouldnt really cause such a problem.
> So now we wonder if this might be an MCE bug, or really a HW problem,
> and if it is one of the CPUs, or the RAM thats faulty.

Consult your hardware vendor but if its a single event in a year it might
be anything - even cosmic rays.

Alan
