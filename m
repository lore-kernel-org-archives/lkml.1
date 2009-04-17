Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZDQBhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZDQBhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbZDQBhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:37:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:5887 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbZDQBhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MV2itfq8KDVCDaTcisYd/bNXysRjGvq2Yt9ui3vfPD4GmJqEsfpB2NNRboeRsIiE7y
         OHFsTLptXZtpjjZMEQY6+NgVTNFulAmHyCa1VF9mgBWzWNxIQavjRfMRQMaoXwDmsfgt
         +zSO5DaEXTvFdfQnBF7GvftuucTBZg+gwNsD0=
MIME-Version: 1.0
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
Date: Fri, 17 Apr 2009 09:37:10 +0800
Message-ID: <d82e647a0904161837w6b6fb652la0da05f9061e95dc@mail.gmail.com>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       video4linux-list@redhat.com, laurent.pinchart@skynet.be,
       mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/17 Rafael J. Wysocki <rjw@sisk.pl>:
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13125
> Subject         : active uvcvideo breaks over suspend
> Submitter       : Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date            : 2009-04-15 10:12 (2 days old)
> References      : http://marc.info/?l=linux-kernel&m=123979009508840&w=4
>

It is a bug in resume path of uvcvideo driver, and I have sent a patch
to laurent.pinchart@skynet.be,
mchehab@infradead.org  and video4linux-list@redhat.com to fix it, but
still no echo from them.

The patch title is V4L/DVB:usbvideo:fix uvc resume failed.

Rafael J.
        If you would like to apply it ,I can resend to you.  Thanks!

-- 
Lei Ming
