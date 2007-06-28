Return-Path: <linux-kernel-owner+w=401wt.eu-S1764372AbXF1JGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764372AbXF1JGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 05:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760140AbXF1JGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 05:06:47 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:64381 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759654AbXF1JGq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 05:06:46 -0400
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: Re: libata-bug in 2.6.21.5 on amd64 with ali chipset
Date: Thu, 28 Jun 2007 11:06:42 +0200
User-Agent: KMail/1.9.7
References: <200706271216.34879.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200706271216.34879.volker.armin.hemmann@tu-clausthal.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706281106.42188.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 27. Juni 2007, you wrote:

> It has worked in the past. I will try different kernels in the next
> 24hours.

I tried this kernels:
2.6.20
2.6.20.1
2.6.21
2.6.21.1
2.6.21.3
2.6.21.5

2.6.21.5 with and without cfs. Every other kernel without cfs. Patched with 
reiser4, nvidia not loaded nor used. All of them locked up. I tried two 
different cdrtools 2.01.01_alpha27 and alpha25. No change.

The strange thing: 2.6.21.1 has worked in the past. At the 21.May I tried 
(successfully) to burn a dvd. The only real change I could find since then: I 
recompiled the whole system to remove 'ricer' cflags. 

Glück Auf
Volker
