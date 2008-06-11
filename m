Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYFKMkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYFKMkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbYFKMkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:40:36 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:32797 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbYFKMkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:40:35 -0400
Date: Wed, 11 Jun 2008 14:40:34 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
In-Reply-To: <200806102152.23286.solstice.dhiver@gmail.com>
Message-ID: <alpine.LNX.1.10.0806111440080.20733@fbirervta.pbzchgretzou.qr>
References: <200806102152.23286.solstice.dhiver@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-06-10 21:52, solsTiCe d'Hiver wrote:
>hi,
>
>i am running a 2.6.25.5-rt6 kernel.
>i know there is no such thing as 2.6.25.5-rt6 yet. so i have checked with a 
>2.6.25.4-rt6 kernel and i have the same issue.

I have 2.6.25.6-rt6 here, so:

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Athlon(tm) XP 2000+
stepping        : 0
cpu MHz         : 1666.737

it's there.
