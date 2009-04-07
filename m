Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbZDGQo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbZDGQo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZDGQok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:44:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:60287 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbZDGQoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dyuc77oYnhBi+IPVgVshTbnyBLnk78oTRF5zjEnXjpQc9VaH1gMeE/vV9eFUmO1LIP
         ZZffEC+HkCCFbv8/5Tp1PxTDGCshO51XME5x4musbLDQgitZToNTz+FvfhPWRAReum14
         R+/AeuUByJWMsEAI0WkCk6iKYn6Sl8biv/s+0=
MIME-Version: 1.0
In-Reply-To: <49DB7C77.1000702@s5r6.in-berlin.de>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain>
	 <49DB7C77.1000702@s5r6.in-berlin.de>
Date: Tue, 7 Apr 2009 10:44:37 -0600
Message-ID: <9b1675090904070944m798ed608i1d9194ebd1ed3961@mail.gmail.com>
Subject: Re: 2.6.29-git13: Reported regressions from 2.6.28
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 7, 2009 at 10:16 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Linus Torvalds wrote:
>> On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
>>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13018
>>> Subject              : 2.6.29 on MacBook 2,1 fails to reboot
>>> Submitter    : Trenton Adams <trenton.d.adams@gmail.com>
>>> Date         : 2009-03-30 2:04 (8 days old)
>>> References   : http://marc.info/?l=linux-kernel&m=123837870307249&w=4
>>> Handled-By   : "Morten P.D. Stevens" <mstevens@win-professional.com>
>>
>
> Trenton,
> could it be the same as this one?
> http://bugzilla.kernel.org/show_bug.cgi?id=12321
> "System hangs when unloading alsa modules"
> http://bugs.gentoo.org/show_bug.cgi?id=253535
> "System hangs when unloading alsa modules on Kernel >2.6.28"
> --
> Stefan Richter
> -=====-==--= -=-- --===
> http://arcgraph.de/sr/
>

The first one looks similar, if not identical.  The second one
doesn't, because my problem happens on 2.6.29 only, not 2.6.28.
Either way, the unload problem with the module didn't happen in
2.6.28.
