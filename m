Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZFHCI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZFHCI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 22:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZFHCIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 22:08:51 -0400
Received: from mail-qy0-f177.google.com ([209.85.221.177]:60389 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbZFHCIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 22:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kMmZUhAwdbet3U1bbJFa/e0vRDrlZkr1yZsTQiDizEAt+DF6sNsRM5bEUln4yiO0Jx
         9ddiri+/wpHtNvtI6MgWtDlCCI+IePUc7cFurLKC/d0CEyEfiZ2pY7gdJZOmnUdHU53p
         nJg+r1M7CYZrYdlqmuUPlgzhFDegFlHYWJAWM=
MIME-Version: 1.0
In-Reply-To: <4A2C103B.7060303@gmail.com>
References: <20090606230137.17029.51286.stgit@t61.ukuu.org.uk>
	 <4A2B80F9.9070103@gmail.com>
	 <9599edfc0906070656u161be30tab0966469a1c9cb1@mail.gmail.com>
	 <4A2C103B.7060303@gmail.com>
Date: Sun, 7 Jun 2009 22:08:52 -0400
Message-ID: <9599edfc0906071908n660b8f5fl738d87275fafe2f8@mail.gmail.com>
Subject: Re: [PATCH] dmi: sanity check BIOS tables
From: Jeff Mitchell <jeffrey.mitchell@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 7, 2009 at 3:08 PM, Jiri Slaby<jirislaby@gmail.com> wrote:
> On 06/07/2009 03:56 PM, Jeff Mitchell wrote:
>> Let me know if I can provide anything more to help debug.
>
> It dies on DMI_BIOS_VERSION. I don't see it, maybe I'm blind, could you
> provide
> dmidecode -u -t 0
> ?
>

Sure.  It's below.  Thanks, again.

# dmidecode 2.9
SMBIOS 2.31 present.

Handle 0x0000, DMI type 0, 20 bytes
        Header and Data:
                00 14 00 00 01 02 91 E7 03 00 90 5F 00 00 00 00
                00 00 82 01
        Strings:
                50 68 6F 65 6E 69 78 20 54 65 63 68 6E 6F 6C 6F
                67 69 65 73 20 4C 54 44 00
                "Phoenix Technologies LTD"
                36 2E 30 30 00
                "6.00"
                30 31 2F 33 30 2F 32 30 30 38 00
                "01/30/2008"
