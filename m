Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbYJUQch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbYJUQch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYJUQc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:32:29 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:43608 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYJUQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:32:29 -0400
Message-ID: <48FE0415.70700@davidnewall.com>
Date: Wed, 22 Oct 2008 03:02:21 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jianjun Kong <jianjun@zeuux.org>
CC: cl@linux-foundation.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fork.c: fix a problem of code style
References: <20081021141647.GA12090@ubuntu>
In-Reply-To: <20081021141647.GA12090@ubuntu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jianjun Kong wrote:
> -	if(max_threads < 20)
> +	if (max_threads < 20)

I thought we didn't bother with trivial style changes like this.
