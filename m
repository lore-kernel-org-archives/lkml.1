Return-Path: <linux-kernel-owner+w=401wt.eu-S1761832AbYBBLuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761832AbYBBLuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758328AbYBBLtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:49:51 -0500
Received: from gw.goop.org ([64.81.55.164]:49997 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758173AbYBBLtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:49:50 -0500
Message-ID: <47A458B1.4050208@goop.org>
Date: Sat, 02 Feb 2008 03:49:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 2 of 7] x86: add common mm/pgtable.c
References: <patchbomb.1201943112@localhost> <3c9aba41ee700a239859.1201943114@localhost> <20080202103030.GA23897@elte.hu>
In-Reply-To: <20080202103030.GA23897@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Add a common arch/x86/mm/pgtable.c file for common pagetable functions.
>>     
>
> randconfig testing found a build breakage on 32-bit, and that got 
> bisected down to this patch of yours.

Couldn't reproduce.  What was the failure?

    J
