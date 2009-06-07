Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZFGTIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZFGTIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 15:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZFGTIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 15:08:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:41926 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbZFGTIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 15:08:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EsVw3Yn0YehRk8DJRAssIidkP78bGXvG+szoJkF3o++w/OqS4T0Xb4Lv28GFDKRmMo
         d96wQkHWMJ12lY4KvHOqVorYCix44b6xpzDeWPdS1BzPfu/zl8WNa++igOIoxZYAjw5D
         RuVwrwo8QSXMR3Zq4afyg7zdKu7qIGAN3/3qM=
Message-ID: <4A2C103B.7060303@gmail.com>
Date: Sun, 07 Jun 2009 21:08:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.2 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Jeff Mitchell <jeffrey.mitchell@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmi: sanity check BIOS tables
References: <20090606230137.17029.51286.stgit@t61.ukuu.org.uk>	 <4A2B80F9.9070103@gmail.com> <9599edfc0906070656u161be30tab0966469a1c9cb1@mail.gmail.com>
In-Reply-To: <9599edfc0906070656u161be30tab0966469a1c9cb1@mail.gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2009 03:56 PM, Jeff Mitchell wrote:
> Let me know if I can provide anything more to help debug.

It dies on DMI_BIOS_VERSION. I don't see it, maybe I'm blind, could you
provide
dmidecode -u -t 0
?
