Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbXHVNfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbXHVNfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 09:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759356AbXHVNex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 09:34:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:24766 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759331AbXHVNer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 09:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=H1wUz08B87H7G4QFWpcJl8lNVb2JxxkKP8MkbqCRjuT4zHLOsXkojgq0cqEJslUPTdYsvyuTJx7iYl6TYLQUISgBnaM1fL1AVXQnEuzyOPJss1lczTQhdfYiX1B1wJUsrkM+5CQVPL++RHkVDdBPhbrWdYbTwNoqtXcVVHm6Xuc=
Message-ID: <46CC3B27.10604@googlemail.com>
Date: Wed, 22 Aug 2007 15:33:27 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


...

 CC      arch/i386/boot/cpu.o
  CC      arch/i386/boot/cpucheck.o
WARNING: "div64_64" [net/netfilter/xt_connbytes.ko] has no CRC!
  CC      arch/i386/boot/edd.o
  AS      arch/i386/boot/header.o
  CC      arch/i386/boot/main.o

...

config : http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/config
build-log: http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/build-log

Regards,

Gabriel
