Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbYEMKGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbYEMKGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYEMKF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:05:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45621 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752375AbYEMKF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:05:56 -0400
Date: Tue, 13 May 2008 10:50:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org, Javier Herrero <jherrero@hvsistemas.es>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 1/2] [8250 Serial Driver]: Added support for 8250-class
 UARTs in HV Sistemas H8606 board
Message-ID: <20080513105031.2418dbbb@core>
In-Reply-To: <1210652069-16788-2-git-send-email-cooloney@kernel.org>
References: <1210652069-16788-1-git-send-email-cooloney@kernel.org>
	<1210652069-16788-2-git-send-email-cooloney@kernel.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 12:14:28 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Javier Herrero <jherrero@hvsistemas.es>
> 
> Added support for 8250-class UARTs in HV Sistemas H8606 board,
> modification in 8250.c driver for correct compilation with Blackfin
> 
> Besides, I think that there is more people using 8250-class UARTs
> with a different hardware than the H8606 board. This code can be shared
> by them.
> 
> Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: Alan Cox <alan@redhat.com>
