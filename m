Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZG0RUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZG0RUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZG0RUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:20:51 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:56884 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751154AbZG0RUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:20:50 -0400
Date: Mon, 27 Jul 2009 13:20:29 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <alpine.DEB.2.00.0907270227420.15760@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0907271320130.13513@gentwo.org>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.Pi.BZObKB@chimera> <4A6CF220.7080605@lwfinger.net> <alpine.DEB.2.00.0907261722140.21259@chino.kir.corp.google.com> <84144f020907270008h2a985278of68e70ff1ee9265c@mail.gmail.com>
 <alpine.DEB.2.00.0907270227420.15760@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.1.10.0907271320132.13513@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, David Rientjes wrote:

> We need DEBUG_FLAGS to determine which flags to mask off to reduce the
> minimum order, so I don't see DEBUG_FLAGS_SIZE as troublesome.
>
> Christoph?

Post a patch? Otherwise just go ahead.

