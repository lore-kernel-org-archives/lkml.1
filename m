Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbXFIT1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbXFIT1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758560AbXFIT1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:27:25 -0400
Received: from main.gmane.org ([80.91.229.2]:53363 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbXFIT1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:27:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: PROBLEM: system clock slow on Athlon AMD64 since 2.6.21
Date: Sat, 9 Jun 2007 19:27:04 +0000 (UTC)
Message-ID: <pan.2007.06.09.19.27.04@free.fr>
References: <200706091453.l59ErWtB026333@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: cac94-1-81-57-151-96.fbx.proxad.net
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 09 Jun 2007 16:53:32 +0200, Mikael Pettersson wrote:

> On Fri, 08 Jun 2007 10:14:03 +0200, Gerard H. Pille wrote:
>> [1.] One line summary of the problem: Since I switched from 2.6.20 to
>> 2.6.21 on my Athlon AMD64 laptop, the system time is slow - about 1' on
>> 15'.
> 
> According to your system description it seems that you have a Targa
> Visionary laptop with a VIA chipset and a Mobile Athlon64. If so, then
> you probably have the same problem I reported some time ago: see
> <http://marc.info/?l=linux-kernel&m=117681226421346&w=2> and the
> followup messages. The conclusion was that the chipset's ACPI PM timer
> slows down when the CPU is in C2.
Isn't possible to chose something other than ACPI PM timer ?


Matthieu

