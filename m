Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYIUV5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYIUV5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 17:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYIUV5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 17:57:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:62196 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYIUV5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 17:57:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=faDd19+kFSws6H3K66LCOpwXVcQPtUDt4v5wnbcRoaz6wQdyOikiQBJk/PWIfZLMiC
         0bFu2AacDccjzjACnvS2vdld47AY3X074VZJlOpXO+LHyBUYRZiQ+65K/53xAW+Uc/Xm
         erOnHw7mCgBWI9dv5x2zIOvLEiiMlWLfSY31k=
Message-ID: <48D6C34F.8070700@gmail.com>
Date: Mon, 22 Sep 2008 01:57:35 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.27-rc6-git6: Reported regressions from 2.6.26
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
In-Reply-To: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,
Correct patch is the one attached to bugzilla entry,
not the one you mention.

Regards,
Alex.

Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11549
> Subject		: 2.6.27-rc5 acpi: EC Storm error message on bootup
> Submitter	: <jmerkey@wolfmountaingroup.com>
> Date		: 2008-09-02 21:27 (20 days old)
> References	: http://marc.info/?l=linux-kernel&m=122039255517586&w=4
> Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
> Patch		: http://marc.info/?l=linux-kernel&m=122098180019264&w=4
>   
