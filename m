Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZDWClA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZDWClA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 22:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZDWCku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 22:40:50 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:38560 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZDWCku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 22:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PbUgbfmzb5f2hfu5DpEMcxk4AXS4KSVrrujeL3CCqVCkoKt46L3CDXzfUkPrrjOhaK
         jDQCakg3fX/QcQaCggULx18xcPAFSmCsG1nhQaqDh/tFFxINtOHnfQO8G90ShrsmGd+L
         Kv3pRv716anwFZ6+dlAGqc18601jw092Cfdgc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904222009340.19256@localhost.localdomain>
References: <alpine.LFD.2.00.0904222009340.19256@localhost.localdomain>
Date: Wed, 22 Apr 2009 22:40:49 -0400
Message-ID: <8bd0f97a0904221940u5023baf1pded7edcee7c66d4c@mail.gmail.com>
Subject: Re: bad references to CONFIG variables from Makefiles
From: Mike Frysinger <vapier.adi@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 20:11, Robert P. J. Day wrote:
> ===== IPIPE =====
> ./arch/blackfin/kernel/Makefile:obj-$(CONFIG_IPIPE)                  += ipipe.o
> ===== IPIPE_TRACE_MCOUNT =====
> ./arch/blackfin/kernel/Makefile:obj-$(CONFIG_IPIPE_TRACE_MCOUNT)     += mcount.o

to be expected
-mike
