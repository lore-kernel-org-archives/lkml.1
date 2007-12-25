Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbXLYRS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbXLYRS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 12:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbXLYRSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 12:18:22 -0500
Received: from h155.mvista.com ([63.81.120.155]:53717 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750744AbXLYRSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 12:18:21 -0500
Message-ID: <47713B7A.9050102@ru.mvista.com>
Date: Tue, 25 Dec 2007 20:18:50 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: linux-mips@ftp.linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [MIPS] MEM_SDREFCFG is not defined for Alchemy DB1550 (compile
 fail)
References: <9e0cf0bf0712230733o3dfd54fcp4962ebf3f84cdff@mail.gmail.com>	 <4770DE51.5000205@ru.mvista.com> <9e0cf0bf0712250904t213d623bp977db54b6be5e3e@mail.gmail.com>
In-Reply-To: <9e0cf0bf0712250904t213d623bp977db54b6be5e3e@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alon Bar-Lev wrote:

>>    PM code is generally broken and unmaintained, so no wonder. I don't
>>remember if anyone has fixed CPU context restoration code (it uses a "skewed"
>>stack frame).

> So suspend modes on these boards are not supported?
> Only "Always On" configuration is supported?

    Sleep mode is supported according to the code. But as I've said PM bits 
haven't been maintained -- probably since the submission.

> Best Regards,
> Alon Bar-Lev.

WBR, Sergei
