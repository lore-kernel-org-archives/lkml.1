Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbZAIVxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbZAIVxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZAIVwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:52:50 -0500
Received: from hpsmtp-eml15.KPNXCHANGE.COM ([213.75.38.115]:43239 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbZAIVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:52:49 -0500
From: Frans Pop <elendil@planet.nl>
To: Roman Medina-Heigl Hernandez <roman@rs-labs.com>
Subject: Re: Oops with Gigabyte motherboard "GA-X48-DQ6" and r8168 Realtek driver
Date: Fri, 9 Jan 2009 22:52:45 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <49671B77.7080705@rs-labs.com>
In-reply-To: <49671B77.7080705@rs-labs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901092252.46448.elendil@planet.nl>
X-OriginalArrivalTime: 09 Jan 2009 21:52:46.0822 (UTC) FILETIME=[9BA47860:01C972A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Medina-Heigl Hernandez wrote:
> It includes two RTL8111/8168B NICs, which seem the cause of the kernel
> crashes (*but I'm not sure*)..., a Quad core, 4GB RAM and two 500GB HDs.
> 
> I installed Debian Linux (4.0) on it and I'm getting *kernel panic*
> errors (r8168 module) when set to production state. I couldn't get any
> kernel debug messages since I'm using Debian stock kernel
> (2.6.18-6-686-bigmem) and I'm not a kernel hacker either.

Have you tried the 2.6.24 kernel that is available for Debian Etch? That 
seems to me the most logical thing to try first as a possible solution.

It was included as part of the "Etch and a half" stable release update 
[1].

Cheers,
FJP

[1] http://www.debian.org/releases/etch/etchnhalf
