Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYCYNjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYCYNjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYCYNjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:39:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbYCYNjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:39:09 -0400
Message-ID: <47E9003B.5010002@zytor.com>
Date: Tue, 25 Mar 2008 06:38:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: yhlu.kernel@gmail.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
References: <200803242324.35357.yhlu.kernel@gmail.com>
In-Reply-To: <200803242324.35357.yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> [PATCH] x86: pat cpu feature bit setting for known cpus
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

OK, note previous question: what is the motivation for having this as a 
whitelist (as opposed to a blacklist)?

	-hpa
