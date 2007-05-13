Return-Path: <linux-kernel-owner+w=401wt.eu-S1759838AbXEMWxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbXEMWxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 18:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXEMWxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 18:53:17 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:55748 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbXEMWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 18:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aRKyHqAIeTeAjua3OeJbaWIB7HDKhd+FwzYBOB3rMMWz2upn0RCb5rJRghfPBVMm6v8d3Xj0gLVft1bnwkRcMvfKvuO9LTsarTyzk/VxTBc2ZFRPD0dxUkvOM0ftkE8XSWO6UVwacyE7VMFP+pXMNu70O1UKElzwNNTV2GPY59o=
Message-ID: <b6a2187b0705131553i24e9b797h41c060b48284a068@mail.gmail.com>
Date: Mon, 14 May 2007 06:53:15 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Ok, the merge window has closed, and 2.6.22-rc1 is out there.

Got this ...

Thanks,
Jeff.

# make config
scripts/kconfig/conf arch/i386/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol
'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
drivers/net/Kconfig:2283:warning: 'select' used by config symbol
'UCC_GETH' refers to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config
symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:181:warning: 'select' used by config
symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
