Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYH0Kvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYH0Kvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYH0Kvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:51:44 -0400
Received: from il.qumranet.com ([212.179.150.194]:35370 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbYH0Kvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:51:44 -0400
Message-ID: <48B531BD.20608@qumranet.com>
Date: Wed, 27 Aug 2008 13:51:41 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
References: <1219659087-17536-1-git-send-email-avi@qumranet.com> <20080826095032.GA309@elf.ucw.cz> <48B3D579.40502@qumranet.com> <20080826113317.520cbab1@lxorguk.ukuu.org.uk> <48B3F3A9.8030709@qumranet.com> <Pine.LNX.4.55.0808261406330.28361@cliff.in.clinika.pl> <87fxorsqdx.fsf@basil.nowhere.org> <20080827091810.GB1688@elf.ucw.cz>
In-Reply-To: <20080827091810.GB1688@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> I'd not count of this. When you relegate laptop to "quiet home server"
> role, the mechanical stresses suddenly stop, and I'd expect it to
> survive for long long years.
>   

For every user who uses an old laptop as a home server, or has a "best 
MIPS64 box", there are maybe five million users with a 0-3 year old x86 
computer (they don't know that it's really a "box").

Let's optimize for the common case, please.

-- 
error compiling committee.c: too many arguments to function

