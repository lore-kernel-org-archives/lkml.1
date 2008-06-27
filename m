Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYF0FTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYF0FTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYF0FSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:18:49 -0400
Received: from gw.goop.org ([64.81.55.164]:56111 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbYF0FSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:18:49 -0400
Message-ID: <48647837.1010601@goop.org>
Date: Thu, 26 Jun 2008 22:18:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 2.6.26-rc7
References: <48616182.9030902@qumranet.com>
In-Reply-To: <48616182.9030902@qumranet.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Gerd Hoffmann (5):
>      x86: Add structs and functions for paravirt clocksource
>      x86: Make xen use the paravirt clocksource structs and functions
>      KVM: Make kvm host use the paravirt clocksource structs
>      x86: KVM guest: Use the paravirt clocksource structs and functions
>      KVM: Remove now unused structs from kvm_para.h

Yeah, I was really expecting this to be .27 material.  The Xen parts of 
the patch look OK, but I can't say I've tested them much - certainly not 
enough to be confident enough to push them in a late -rc.

    J
