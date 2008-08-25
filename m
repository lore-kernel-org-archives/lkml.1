Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbYHYAT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbYHYAT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 20:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYHYATt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 20:19:49 -0400
Received: from khc.piap.pl ([195.187.100.11]:39061 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbYHYATs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 20:19:48 -0400
To: Jari Aalto <jari.aalto@cante.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
References: <fa.c8YPWdZHXAabbZwTVLAgq9ahOlE@ifi.uio.no>
	<fa.9B7J3O7801PlFtm4WwuBX/J0kU8@ifi.uio.no>
	<fa.ES0QYHe349FfrOTaqTun1n3qaYk@ifi.uio.no>
	<fa.8FK+C3lDiXBnZCV9FTofTkm6PJE@ifi.uio.no>
	<fa.cN6j0N4TRlTlG7oLEhhT8Wj2N7A@ifi.uio.no>
	<fa.XwRqZTkk0olSp3UUnbSFZahR4TI@ifi.uio.no> <48B1D82C.5000107@shaw.ca>
	<87d4jyys7y.fsf@jondo.cante.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 25 Aug 2008 02:19:46 +0200
In-Reply-To: <87d4jyys7y.fsf@jondo.cante.net> (Jari Aalto's message of "Mon\, 25 Aug 2008 01\:16\:01 +0300")
Message-ID: <m3hc9akkt9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jari Aalto <jari.aalto@cante.net> writes:

> What, if after booting to 2.6.26 and without any 'iommu' boot parameters,
> there still appears "Out of Iommu space" messages? What kind of logs
> should I post?

You shouldn't be getting "Out of SW-IOMMU space" messages when not
using SW-IOMMU.

> I'm a bit nervous due to past experience of complete hardd disk
> corruption. But if that was problem with the old kernel and more later
> versions are safer in this repect, I could once more.

I'm not sure if the newer versions are safer. It may be a hardware/BIOS
problem and it may happen again. Make sure you have a usable backup
first.
-- 
Krzysztof Halasa
