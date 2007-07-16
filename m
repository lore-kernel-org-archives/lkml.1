Return-Path: <linux-kernel-owner+w=401wt.eu-S1764492AbXGPWdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764492AbXGPWdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXGPWdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:33:42 -0400
Received: from gw.goop.org ([64.81.55.164]:39679 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbXGPWdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:33:41 -0400
Message-ID: <469BF20A.3020606@goop.org>
Date: Mon, 16 Jul 2007 15:32:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, ak@suse.de
Subject: Re: powerd in arch/sparc64/kernel/power.c
References: <469BC777.5010207@goop.org> <20070716.150057.59832795.davem@davemloft.net>
In-Reply-To: <20070716.150057.59832795.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Put the generic code in and I'll try to make use of it in sparc64.
> I have two spots that need it now.
>   

OK, I'll drop the sparc64 parts of the patch and let you do the followup.

    J
