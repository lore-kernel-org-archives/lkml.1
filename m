Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbYLLRSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbYLLRSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYLLRS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:18:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39962 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbYLLRS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:18:26 -0500
To: "Marcello Henrique" <faraohh@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Auto generate .config.
From: Andi Kleen <andi@firstfloor.org>
References: <f5cc88f60812120747w47c762a7qcee62fdfa10d6ac6@mail.gmail.com>
	<49428DF8.2090205@diamondcut.com.br>
	<f5cc88f60812120820i4252962er2fa6d3483c2ae412@mail.gmail.com>
Date: Fri, 12 Dec 2008 18:18:45 +0100
In-Reply-To: <f5cc88f60812120820i4252962er2fa6d3483c2ae412@mail.gmail.com> (Marcello Henrique's message of "Fri, 12 Dec 2008 14:20:22 -0200")
Message-ID: <87skotb9ca.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Marcello Henrique" <faraohh@gmail.com> writes:
>
> The idea is that the kernel of my distribution is too fat and I only
> generate a kernel module that I use automatically from a kernel fat.
> understand?

While it sounds like a good idea initially you'll regret it once you
plug in some USB device and find that you miss its driver.

-Andi
-- 
ak@linux.intel.com
