Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbYIIGvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbYIIGvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYIIGvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:51:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45128 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbYIIGvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:51:12 -0400
Date: Tue, 9 Sep 2008 08:51:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] init/initramfs.c: unused function when compiling
	without CONFIG_BLK_DEV_RAM
Message-ID: <20080909065101.GA27747@elte.hu>
References: <1220915951-11434-1-git-send-email-steven@uplinklabs.net> <1220915951-11434-2-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220915951-11434-2-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> Fixing compiler warning when the kernel isn't compiled with support
> for RAM block devices enabled.
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>

applied to tip/fastboot - thanks Steven!

	Ingo
