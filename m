Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbYE0PiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbYE0PiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbYE0Ph4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:37:56 -0400
Received: from www.tglx.de ([62.245.132.106]:51444 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170AbYE0Ph4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:37:56 -0400
Date: Tue, 27 May 2008 17:37:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] hpet: push BKL down into hpet driver
In-Reply-To: <20080522213933.3639eac4@core>
Message-ID: <alpine.LFD.1.10.0805271736530.3295@apollo.tec.linutronix.de>
References: <20080522213933.3639eac4@core>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@redhat.com>

Apllied. Thanks,

	 tglx
