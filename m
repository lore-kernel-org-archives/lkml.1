Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYGGQie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYGGQie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYGGQi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:38:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48070 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYGGQiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:38:25 -0400
Date: Mon, 7 Jul 2008 18:38:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Bradley Hanna <brahan.ml@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Does the kernel detect arch features when making config?
In-Reply-To: <4870EEE2.6060700@gmail.com>
Message-ID: <alpine.LNX.1.10.0807071838100.8248@fbirervta.pbzchgretzou.qr>
References: <4870EEE2.6060700@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 2008-07-06 18:12, Bradley Hanna wrote:

>Does the kernel detect the specifics of the my computer architecture
>when a defconfig is run?

no.

>It just seems like when I run defconfig the kernel knows to configure
>for a 64 bit system.

only because you run it in a 64 bit environment to begin with.

