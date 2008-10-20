Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbYJTXXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbYJTXXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYJTXWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:22:53 -0400
Received: from www.tglx.de ([62.245.132.106]:53853 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYJTXWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:22:53 -0400
Date: Tue, 21 Oct 2008 01:22:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tip is broken with NOHZ: restart tick device from irq_enter()
In-Reply-To: <86802c440810201601s78a605f4l98624eedbc108d33@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0810210118380.3301@apollo>
References: <86802c440810201601s78a605f4l98624eedbc108d33@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, Yinghai Lu wrote:

> all my servers are broken with following commit.

Can you please explain what exactly is broken ?

Thanks,

	tglx
