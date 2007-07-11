Return-Path: <linux-kernel-owner+w=401wt.eu-S1760474AbXGKIlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474AbXGKIlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbXGKIlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:41:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:4866 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXGKIlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=SVBS4E+iIFICgsl6tcrWnlgKVkQuO1pzdbbMj29J71U5rG37tk1OqdFPEZ67AQzFcEHoB645afXKgyLYjOXi3lmioUFo/CDvu4giXGHpf+KCBPvswB7Bk8sXmPROAPkXBEYtnvanFRjXRvlV2YXWdMNL6zQ/wVv/GsZ/g5P9WQs=
Message-ID: <84144f020707110141pd8912aaw9df05d665a35d482@mail.gmail.com>
Date: Wed, 11 Jul 2007 11:41:35 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: revoke (Was: -mm merge plans for 2.6.23)
Cc: linux-kernel@vger.kernel.org, "Christoph Hellwig" <hch@lst.de>,
       viro@zeniv.linux.org.uk, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: c5cf1079a852a166
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 7/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> revoke-special-mmap-handling.patch
> revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
> revoke-core-code.patch
> revoke-support-for-ext2-and-ext3.patch
> revoke-add-documentation.patch
> revoke-wire-up-i386-system-calls.patch
> fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
> revoke-vs-git-block.patch
>
>  Don't know.  Need to ping suitable developers over this work.

Well, revoke is in limbo land waiting for the VFS maintainers to take
a look at it...
