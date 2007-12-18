Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbXLRNvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbXLRNvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 08:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbXLRNvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 08:51:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656AbXLRNvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 08:51:12 -0500
Message-ID: <4767D005.6040909@redhat.com>
Date: Tue, 18 Dec 2007 11:49:57 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 21/21] [PATCH] finish processor.h integration
References: <11979320354186-git-send-email-gcosta@redhat.com> <11979320401316-git-send-email-gcosta@redhat.com> <11979320451308-git-send-email-gcosta@redhat.com> <1197932050948-git-send-email-gcosta@redhat.com> <11979320551036-git-send-email-gcosta@redhat.com> <11979320603229-git-send-email!-gcosta@redhat.com> <11979320653161-git-send-email-gcosta@redhat.com> <11979320693300-git-send-email-gcosta@redhat.com> <20071218131932.GA9457@elte.hu> <20071218133818.GA9941@elte.hu> <20071218134018.GA13193@elte.hu>
In-Reply-To: <20071218134018.GA13193@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> yes, our include file dependencies are a jungle, the differences 
>> between 32-bit and 64-bit are arbitrary in 80% of the cases, but still 
>> there's no reason why this couldnt be done correctly. The patch below 
>> is a quick bandaid that adds the missing bits.
> 
> the bandaid didnt work - so i removed the 21/21 patch for the time 
> being.
I will also have updates for other patches, If you want, you can drop 
the series entirely,
and wait for the new one to come


