Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZEIQc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZEIQc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZEIQcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:32:20 -0400
Received: from a2s31.a2hosting.com ([69.39.67.40]:36900 "EHLO
	a2s31.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbZEIQcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:32:20 -0400
MIME-Version: 1.0
Date: Sat, 09 May 2009 12:32:19 -0400
From: <v.virvilis@biovista.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SATA disks resets in a md setup
In-Reply-To: <1241854465.1876.10.camel@unix>
References: <200905081739.46206.v.virvilis@biovista.com> <1241854465.1876.10.camel@unix>
Message-ID: <0bcad3053dca968ec1de00ee18c34f08@biovista.com>
User-Agent: RoundCube Webmail/0.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s31.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - biovista.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 May 2009 00:34:25 -0700, "Justin P. Mattock"
<justinmattock@gmail.com> wrote:

> Have you tried 2.6.29?

Yep the log was with 2.6.29

> i.g. I've noticed that /dev/hd*
> was changed to /dev/sd* with some distro's,
> (or maybe it was the kernel(who knows!!))
> which in some cases, causes some confusion between 
> grub/lilo etc..

grub / lilo has nothing to do with that. The drive under stress
resets. Sometimes the reset works sometimes fails and I end up with
a broken filesystem


       .bill


