Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064Ab0AXXIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab0AXXIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466Ab0AXXIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:08:42 -0500
Received: from mail-iw0-f183.google.com ([209.85.223.183]:51429 "EHLO
	mail-iw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0AXXIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:08:41 -0500
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jan 2010 18:08:41 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wMgIm1eTvb6iOv6tJ3k8y4HPt/p6sfoEsmCBxDpIjFZ8cEWpqz7W9fbxISchrCPsv3
         VpR1WP0/GT2Eb/VF3IsbNJNHGuUXRLuTwtfTdLpQKubn1Fk4WnmRdvUwYQKRKNAvyMIa
         1R31IEQV58DSnsOlp3JsN3lqIhdRIThgqUuLQ=
Message-ID: <4B5CD17F.6070606@gmail.com>
Date: Sun, 24 Jan 2010 15:02:23 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5
 cr2 0
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.wCC.jbMXLB@chimera>
In-Reply-To: <q60Z28d_9yH.A.wCC.jbMXLB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/10 14:22, Rafael J. Wysocki wrote:
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
> Date		: 2009-10-23 16:45 (94 days old)
> References	: http://lkml.org/lkml/2009/10/23/252
>
>
>

yeah I'm still seeing this during boot.
As of looking at this, been tied up with another
issue and totally forgot. next week I'll be away
for a week, and during that period I can try and look at this
since I might be hanging around at times.
(and wont be side tracked with the other issue I was looking at);

So yeah please keep it open, and hopefully somebody
see's what is happening and maybe has a solution, or
by chance maybe I can figure something.

Justin P. Mattock
