Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbZFQPfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbZFQPfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZFQPfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:35:10 -0400
Received: from claw.goop.org ([74.207.240.146]:50355 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbZFQPfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:35:09 -0400
Message-ID: <4A390D20.7010402@goop.org>
Date: Wed, 17 Jun 2009 08:34:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 00/16] Cleanups to io_apic.c
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/09 13:15, Jeremy Fitzhardinge wrote:
> Hi Ingo,
>
> Here's a series of little cleanup patches to kernel/apic/io_apic.c which
> I fixed as I was reviewing the code.
>    

Hm, patches 1-4 in this series are a mistake; I guess I managed to 
specify the base version wrongly or something.  5-16 are what I intended 
to send.

The git tree at 
"git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git 
apic-cleanup" is fine.

     J
