Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZAEPUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZAEPUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZAEPTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:19:30 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57403 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756789AbZAEPT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:19:29 -0500
Date: Mon, 5 Jan 2009 16:17:54 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>, hskinnemoen@atmel.com,
       marc.pignat@hevs.ch, linux-kernel@vger.kernel.org
Subject: Re: atmel_serial might lose modem status change
Message-ID: <20090105161754.07750839@hskinnemoen-d830>
In-Reply-To: <3efb10970811121104o7497d354n6730a23ce5756093@mail.gmail.com>
References: <20081113.021601.30439144.anemo@mba.ocn.ne.jp>
	<3efb10970811121104o7497d354n6730a23ce5756093@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remy Bohmer wrote:
> > I suppose irq_status_prev should be initialized at somewhere in open
> > sequence.  Is this fix correct?  
> 
> I cannot shoot a hole in it... So, to me it appears okay.

Looks good to me too.

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
