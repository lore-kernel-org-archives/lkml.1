Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbYFBTZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbYFBTZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbYFBTZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:25:18 -0400
Received: from gw.goop.org ([64.81.55.164]:43154 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbYFBTZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:25:15 -0400
Message-ID: <484448F6.9000403@goop.org>
Date: Mon, 02 Jun 2008 20:24:38 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: More e820 unification?
References: <48441AFF.3020204@goop.org> <86802c440806021114m51ba9148ge69d8ded228d888f@mail.gmail.com>
In-Reply-To: <86802c440806021114m51ba9148ge69d8ded228d888f@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> [PATCH] x86: cleanup max_pfn_mapped usage - 32bit
> may need you update xen pv to specify max_pfn_mapped early stage...

Ah, yes, I saw your mail.  What exactly does that value mean?  What 
should I set it to?

    J
