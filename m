Return-Path: <linux-kernel-owner+w=401wt.eu-S1765020AbYCGTOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765020AbYCGTOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764348AbYCGTOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:14:21 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:19453 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764290AbYCGTOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:14:20 -0500
To: Bill Davidsen <davidsen@tmr.com>
Cc: Justin Banks <justinb@bakbone.com>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FW: Linux question
References: <DEE40752C8AF224BB890E455C7B8E0FE042B84B112@G6W0268.americas.hpqcorp.net>
	<20080306203841.GA4282@bleen.domain.actdsltmp>
	<47D18CE1.7050206@tmr.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 07 Mar 2008 20:14:12 +0100
In-Reply-To: <47D18CE1.7050206@tmr.com>
Message-ID: <874pbifit7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Mar 2008 19:07:42.0517 (UTC) FILETIME=[84FC7650:01C88086]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen <davidsen@tmr.com> writes:

> Here's an interesting question, why isn't there an "online" file for
> each CPU?

There are still some problems with off lining CPU #0 on x86 at least,
that is why it is not allowed. iirc they weren't very difficult so it
would be probably fixable with some effort.

-Andi
