Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZFRB4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZFRB4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZFRB40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:56:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52372 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbZFRB4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:56:25 -0400
Message-ID: <4A399EC1.8030201@jp.fujitsu.com>
Date: Thu, 18 Jun 2009 10:56:17 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mce fix type
References: <4A396361.2000302@kernel.org> <4A396384.5030703@kernel.org>
In-Reply-To: <4A396384.5030703@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> can not have two ignore_ce
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Thank you for finding it!

Acked-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

