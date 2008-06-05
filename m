Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbYFEOoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbYFEOoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYFEOoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:44:11 -0400
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:44240 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197AbYFEOoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:44:10 -0400
From: Frans Pop <elendil@planet.nl>
To: Thomas Bleher <ThomasBleher@gmx.de>
Subject: Re: ARM on qemu: running kernel 2.6.20 or newer?
Date: Thu, 5 Jun 2008 16:44:06 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, dada1@cosmosbay.com
References: <20080605135149.GA20870@j-crew.de>
In-reply-To: <20080605135149.GA20870@j-crew.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806051644.07430.elendil@planet.nl>
X-OriginalArrivalTime: 05 Jun 2008 14:44:08.0575 (UTC) FILETIME=[9C51E8F0:01C8C71A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Bleher wrote:
> I'm trying to run an ARM kernel on qemu (0.9.1-5) on a Debian AMD64
> system. 2.6.19 worked fine, but all newer kernel releases[1] result in
> qemu consuming 100% of the CPU without ever outputting anything to the
> console.

The daily built armel versatile D-I images [1] worked fine for me in qemu 
just a few days ago. They use 2.6.24. There's one issue [2] related to 
serial console, but graphics mode works fine.

Cheers,
FJP

[1] http://wiki.debian.org/ArmEabiHowto
[2] http://bugs.debian.org/484366
