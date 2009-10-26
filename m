Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbZJZTPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbZJZTPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbZJZTPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:15:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:51079 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbZJZTPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rKylKRF/ZLfBm+VwhUIPwcK19EglZyJYRsDWUwt8t/KPfp8ZGHmLN4M6+lYN2SPxho
         V8A6JLscK1Tvi9tWi4ijxqjYyWquioAg/iJ6MwdbzIrkTlFCjQEZcVwHFp4ZZmLm5J27
         0z6OmgGX1yWtUZCiJ9FfdFW/FPMxwuYAWhXHk=
Message-ID: <4AE5F563.5020803@gmail.com>
Date: Mon, 26 Oct 2009 12:15:47 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [Bug #14379] ACPI Warning for _SB_.BAT0._BIF: Converted Buffer
 to expected String
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.Z4G.kre5KB@chimera>
In-Reply-To: <6dRYo8ss7vL.A.Z4G.kre5KB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14379
> Subject		: ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
> Submitter	: Justin Mattock<justinmattock@gmail.com>
> Date		: 2009-10-08 21:46 (19 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9adc2e031bd22d5d9607a53a8d3b30e0b675f39
> References	: http://marc.info/?l=linux-kernel&m=125504031328941&w=4
> Handled-By	: Alexey Starikovskiy<astarikovskiy@suse.de>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=23347
>
>
>
>    
The patch submitted gets rid of the warning
for people crying wolf!! but probably would not close
the bugreport until the patch makes it into the main
kernel.

Justin P. Mattock
