Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYHZKF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYHZKF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYHZKFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:05:47 -0400
Received: from il.qumranet.com ([212.179.150.194]:23536 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbYHZKFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:05:46 -0400
Message-ID: <48B3D579.40502@qumranet.com>
Date: Tue, 26 Aug 2008 13:05:45 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
References: <1219659087-17536-1-git-send-email-avi@qumranet.com> <20080826095032.GA309@elf.ucw.cz>
In-Reply-To: <20080826095032.GA309@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> "ACPI" and "safe" in one sentence. /me bets this will break lot of
> machines.
>
>   

We're in 2008 according to date(1).

> What about only doing that when enabling VT?
> 								Pavel
>
>   

It seems excessive.  Most machines will hardly run without acpi.

-- 
error compiling committee.c: too many arguments to function

