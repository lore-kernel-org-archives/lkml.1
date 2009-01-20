Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbZATBqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbZATBqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZATBqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:46:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:42813 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZATBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:46:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W4MU190Cd2r87BFDWGOBk7jFYBLfIBNfB9jy7QLZyGgDoOO3zkXS0Gd1o9I9ZOykp1
         q31vQYNiDAzVuJifLONj3tv4jbwQQSk5Wc+SC8AoPzL3HyC7pJe4OTVJCJCSuSjccgKV
         yn0hi0Rzq3anTyLTEhCxTQii6W9EojJDpkjYM=
Message-ID: <b6a2187b0901191746u1139d09es22d6c5177635a65@mail.gmail.com>
Date: Tue, 20 Jan 2009 09:46:05 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Daniel Drake" <dsd@gentoo.org>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Phil Dibowitz" <phil@ipom.com>,
       "Harvey Harrison" <harvey.harrison@gmail.com>
In-Reply-To: <2QN7KFic7LG.A.pF.59QdJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
	 <2QN7KFic7LG.A.pF.59QdJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 5:32 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12422
> Subject         : 2.6.28-git can't resume from str
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-01-10 1:39 (10 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a0d4922da2e4ccb0973095d8d29f36f6b1b5f703
> References      : http://marc.info/?l=linux-kernel&m=123155157909282&w=4
>                  http://marc.info/?l=linux-kernel&m=123167815028388&w=4
> Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> Patch           : http://lkml.org/lkml/2009/1/13/144

Rafael,

Confirmed the patch fixed resume from STR. No problem for the past 10 days.

Thanks,
Jeff.
