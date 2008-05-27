Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYE0NeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYE0NeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbYE0Ndz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:33:55 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:62805 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbYE0Ndy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mrcHuWjCPgihKwGXeetIQKCyCpz/BBN6ay3JkfQu3nfKiC0fzzHW3I5vr8rJDTBpapeIhVX7eDzlHL5EgV0UceMYM+WO+1etto5gWXwghKgq3A9DczKlQmekBPubFg0e+ZC6WON2XY+cqOU1+lCpoZQUFjMx8N28Wo1HzdG8dag=
Message-ID: <483C0DBF.6030702@gmail.com>
Date: Tue, 27 May 2008 15:33:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Noel (Sourceforge)" <noelb@users.sourceforge.net>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PROBLEM: Serial error
References: <1211836442.5745.1.camel@roswell.ausics.net> <483B3B7C.1000306@gmail.com> <483C0CDD.2000409@gmail.com>
In-Reply-To: <483C0CDD.2000409@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
>>> 01:0c.0 Serial controller: PLX Technology, Inc. PCI <-> IOBus Bridge
>>> (rev 01) (prog-if 00 [8250])
>>>         Subsystem: Stallion Technologies, Inc. Unknown device f010
>>
>> Do you have some patched driver or whatever, that this binds?

And please post
lspci -vvxxs 01:0c.0

I didn't get how this binds to *stallion drivers.
