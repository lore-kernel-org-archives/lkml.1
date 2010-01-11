Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328Ab0AKN53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0AKN53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 08:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673Ab0AKN52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 08:57:28 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57694 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab0AKN51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 08:57:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sD/ZHiZXErtCvcdAXVI8z5RrR2FTnudxIfrW0VkK/0urD3NLKwwYv0Hws4ovtDrR5J
         Fq1tMjcWynVDXvdHRFz69gaxr3lS7yC61GVu5dOF2KlWlsFIQEMkBml3Ov8H/S+YwRRf
         Sg18pNau8aclK5ZYE+VSD2TpOSsR27nw6cPo4=
Message-ID: <4B4B2E22.6030903@gmail.com>
Date: Mon, 11 Jan 2010 05:56:50 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5
 cr2 0
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A.O1D.qilSLB@chimera>
In-Reply-To: <CXIfLt-ygXM.A.O1D.qilSLB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/10 14:56, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
> Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> Date		: 2009-10-23 16:45 (80 days old)
> References	: http://lkml.org/lkml/2009/10/23/252
>
>
>

I've played around with this. and
and much confused at what needs to happen.
(please feedback on what might be happening);
In any case I can have another try at finding a fix
so please leave open.

Justin P. Mattock
