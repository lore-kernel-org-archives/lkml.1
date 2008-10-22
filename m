Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYJVPm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYJVPm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYJVPmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:42:47 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:39257 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbYJVPmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:42:46 -0400
Date: Wed, 22 Oct 2008 16:42:44 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Glauber Costa <glommer@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
In-Reply-To: <5d6222a80810220717u758b69a9x5bdbc32385c81c52@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0810221641450.24509@ftp.linux-mips.org>
References: <20081022140009.GA9639@localhost> <20081022141354.GA26372@elte.hu> <5d6222a80810220717u758b69a9x5bdbc32385c81c52@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Glauber Costa wrote:

> It's a Xeon, so probably just weird.

 The change would not affect it in any way then, because the condition is 
true.

  Maciej
