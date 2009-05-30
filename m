Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbZE3Ilm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbZE3Ilm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbZE3Il1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:41:27 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:40535 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZE3IlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=r7DkrNi+RAryh4e5oQZqkX7dY9RJ05HMG6adT+LmKJT/+KLsPJe1EvUJmi7aVOwi3J
         c/TRmXxO+XEdTPdHr910oK36limQQ3Sdn/zRQnlvU/e2/HaJjAnwUQ1rLt+ShguEt6m1
         LHnyNXQMWFM4OQq3jSvq7Zd/Mgi3ONOmjiCos=
Message-ID: <4A20F130.8010903@gmail.com>
Date: Sat, 30 May 2009 10:41:20 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc7: Reported regressions 2.6.28 -> 2.6.29
References: <cFumJ-4vi-3@gated-at.bofh.it>
In-Reply-To: <cFumJ-4vi-3@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message contains a list of some regressions introduced between 2.6.28 and
> 2.6.29, for which there are no fixes in the mainline I know of.  If any of them
> have been fixed already, please let me know.
<snip>
> Please let me know if there are any Bugzilla entries that should be added to
> the list in there.

Hi Rafael,

Can you please add http://bugzilla.kernel.org/show_bug.cgi?id=13017

This relates to resume issues that lead to EXT4 file-system errors, with symptoms being ATA bus errors.

Regards,
Miel
