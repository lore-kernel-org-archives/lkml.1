Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0BUWak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:30:40 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:55866 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0BUWai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:30:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XBje6UInCKNUQED3NjXk2eELZ3ht85fC0RB8wzzgddqfzJUgjD+vZeQxEGT7SnG+S7
         hWQlbRcQE0dxeyQ0bJgxhsQcVz8Or+FFFBdCoTPKufFdhi+LkuNiI0F0ULZgfd3r9meD
         eRRhDOKdHiftlpw1nOcaV0nxpgztFIyn7mTBY=
Message-ID: <4B81B2CB.50503@gmail.com>
Date: Sun, 21 Feb 2010 14:25:15 -0800
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5
 cr2 0
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera> <wj3ZQZlk_KB.A.bPD.FxagLB@chimera>
In-Reply-To: <wj3ZQZlk_KB.A.bPD.FxagLB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2010 01:42 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
> Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> Date		: 2009-10-23 16:45 (122 days old)
> References	: http://lkml.org/lkml/2009/10/23/252
> Handled-By	: Jan Beulich<jbeulich@novell.com>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


yeah still here.. worst is I'm able to see this with
suse11.2 as well as with my custom system.

so please leave open.

Justin P. Mattock
