Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYCYMcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYCYMcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 08:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYCYMcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 08:32:13 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:46344 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbYCYMcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:32:12 -0400
Message-ID: <47E8EEDC.3010700@aitel.hist.no>
Date: Tue, 25 Mar 2008 13:23:56 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-mm1 shutdown crash
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>	<47D93435.1080402@aitel.hist.no> <20080313091250.33faaa59.akpm@linux-foundation.org>
In-Reply-To: <20080313091250.33faaa59.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
[...]
> Yes, I was hitting the text_poke() oops with 2.6.25-rc3-mm1 but not with
> 2.6.25-rc5-mm1.
>
> This _might_ have been due to a snafu in git-x86: it had a [patch 2/2] from
> Mathieu but was missing the needed [patch 1/2].  But I don't know if this
> was the cause and I don't know whether 2.6.25-rc3-mm1's git-x86 had the
> same problem.
>   
The problem seems to be solved in 2.6.25-rc6.

Helge Hafting
