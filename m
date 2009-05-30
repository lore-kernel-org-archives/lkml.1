Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbZE3Ke4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbZE3Ke4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbZE3Ket
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:34:49 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:34092 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbZE3Ket (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:34:49 -0400
Message-ID: <4A210BC0.708@f2s.com>
Date: Sat, 30 May 2009 11:34:40 +0100
From: Ian molton <spyro@f2s.com>
Reply-To: ian@mnementh.co.uk
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Philipp Zabel <philipp.zabel@gmail.com>
CC: linux-kernel@vger.kernel.org, Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 3/5] mmc: tmio_mmc: don't use set_irq_type
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com> <1243279681-4233-4-git-send-email-philipp.zabel@gmail.com>
In-Reply-To: <1243279681-4233-4-git-send-email-philipp.zabel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ian Molton <ian@mnementh.co.uk>

Again though, lines over 80 characters - but not up to me.

Philipp Zabel wrote:
> Use an IRQF_TRIGGER_ flag in request_irq instead.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Pierre Ossman <pierre@ossman.eu>
> Cc: Ian Molton <spyro@f2s.com>
