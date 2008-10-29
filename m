Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYJ2Gbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYJ2Gbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJ2Gbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:31:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43224 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbYJ2Gbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:31:31 -0400
Message-ID: <49080347.70503@redhat.com>
Date: Wed, 29 Oct 2008 08:31:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2 : KVM FAIL
References: <f7848160810271515v65007926g8537c43c67f1bd72@mail.gmail.com>
In-Reply-To: <f7848160810271515v65007926g8537c43c67f1bd72@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> With today's git host kernel I can no longer boot my Ubuntu virtual
> machine - udevd, modprobe etc. just die with glibc detecting realloc()
> errors (invalid next size) and I am dropped to initramfs prompt.
>
> Going back to the distro kernel 2.6.26 makes the same VM work again.
>   

Please pull again and retry.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

