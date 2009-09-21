Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZIUT0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZIUT0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZIUT0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:26:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34339 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbZIUT0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:26:20 -0400
Message-ID: <4AB7D349.4000802@zytor.com>
Date: Mon, 21 Sep 2009 12:26:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tony Vroon <tony@linx.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
References: <1253560490.2934.42.camel@localhost>
In-Reply-To: <1253560490.2934.42.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Vroon wrote:
> 
> Last known working kernel is:
> Linux prometheus 2.6.31-03123-g99bc470 #1 SMP Mon Sep 14 22:53:06 BST
> 2009 x86_64 Six-Core AMD Opteron(tm) Processor 2435 AuthenticAMD
> GNU/Linux
> (dmesg for normal operation in g99bc470 kernel attached)
> 
> Happy to provide any further information that you may require.
> 

Could you please do a git bisect on this problem?

	-hpa

