Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795Ab0AGUW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0AGUW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651Ab0AGUW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:22:57 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45733 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0AGUW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:22:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VCWb4W1SRJQJyuZ38q4o14t0u/RSl8W6AvJSGI3Pu793Gv1/t+BBlhnGxFc8TBtbFl
         qOXrdmR8kIGZaKTw7RvZm4EgfjP56KaAMyJdclCa5p/lXZtbH9nH5b4dD0TA/HXXohqa
         ysiE6SRfUZ9vn6T78LkWz4KBxMCiiIFuKPJZc=
MIME-Version: 1.0
In-Reply-To: <2d0a357f1001071214m6780def8md80c056161d0aa79@mail.gmail.com>
References: <8db1092f1001071136o20ac7e19nb102c7afde8c21e7@mail.gmail.com>
	 <2d0a357f1001071214m6780def8md80c056161d0aa79@mail.gmail.com>
Date: Thu, 7 Jan 2010 21:22:53 +0100
Message-ID: <8db1092f1001071222i1844e559g75e6067faf05fb63@mail.gmail.com>
Subject: Re: [2.6.33-rc3] [WMI?] [RFKILL?] [WIRELESS?] hang: BUG: Unable to 
	handle kernel NULL pointer dereference at 00000008
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: sedat.dilek@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       carlos@strangeworlds.co.uk,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>, ilw@linux.intel.com,
       len.brown@intel.com, Anisse Astier <anisse@astier.eu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/7 Sedat Dilek <sedat.dilek@googlemail.com>:
> Hi,
>
> seems like the ACPI/hp-wmi bug, nothing to do with linux-wireless.
>
> I have already reported this bug (again) [1] and unfortunately it has
> re-entered upstream.
> A single new patch was sent by Anisse [2].
> This patch is waiting in linux-acpi-2.6/test [3].
>
> Don't ask me why it has not been included in 2.6.33-rc3.
> For some HP-notebook users it is a CRITICAL bug.
>
> Kind Regards,
> - Sedat -
>
> [1] http://marc.info/?t=126227644600001&r=1&w=2
> [2] http://marc.info/?t=126215864800004&r=1&w=2
> [3] http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commit;h=c9c041fcb1a4d69ed4791f00b57554eeb341d148
>



Thanks for the answer.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
