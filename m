Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYJ2Xma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYJ2Xma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYJ2XmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:42:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:5968 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbYJ2XmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eb/Kb5zaNaeqTRcLTFT/a66iAT76oy7SQVNrqy7OPBdPdXTnjCNAzoGV9rhLhCHFL+
         CN/RuR57Uz6WxqRtwfvvQR2zVuL++yBB0sHmXUSxupX/6KB+Kg+CNvRmeeCY5oeQNIbH
         9O00ssb0wVbzam8p6+IDpdKAL0rD4T5ojBoIA=
Message-ID: <f7848160810291642y5263635ao6ce5ed4f11152b31@mail.gmail.com>
Date: Wed, 29 Oct 2008 19:42:21 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Avi Kivity" <avi@redhat.com>
Subject: Re: 2.6.28-rc2 : KVM FAIL
Cc: "Avi Kivity" <avi@qumranet.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49080347.70503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f7848160810271515v65007926g8537c43c67f1bd72@mail.gmail.com>
	 <49080347.70503@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 2:31 AM, Avi Kivity <avi@redhat.com> wrote:
> Parag Warudkar wrote:
>>
>> With today's git host kernel I can no longer boot my Ubuntu virtual
>> machine - udevd, modprobe etc. just die with glibc detecting realloc()
>> errors (invalid next size) and I am dropped to initramfs prompt.
>>
>> Going back to the distro kernel 2.6.26 makes the same VM work again.
>>
>
> Please pull again and retry.
>

Worked fine - thanks.

Parag
