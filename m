Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbYDKLM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbYDKLM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759370AbYDKLMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:12:16 -0400
Received: from public.bindows.net ([66.135.40.169]:41044 "EHLO
	public.bindows.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759323AbYDKLMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:12:15 -0400
Message-ID: <47FF4781.3040506@better.se>
Date: Fri, 11 Apr 2008 13:12:01 +0200
From: Marcus Better <marcus@better.se>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stefanr@s5r6.in-berlin.de, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Bug 10327] New: keyboard stops responding after "ifdown eth0"
References: <bug-10327-10286@http.bugzilla.kernel.org/>	<20080325143941.300d415f.akpm@linux-foundation.org>	<47E9721C.2000306@better.se>	<47E99258.3060005@s5r6.in-berlin.de>	<20080325171608.509f4ca7.akpm@linux-foundation.org>	<47EA152C.6000008@better.se> <20080326102931.484285f3.akpm@linux-foundation.org>
In-Reply-To: <20080326102931.484285f3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I'd suggest running (and perhaps suitably modifying) this:

This doesn't seem to help, it freezes without printing anything, and 
there is nothing in the logs either.
