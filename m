Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbZCDTOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbZCDTOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZCDTO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:14:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:58402 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZCDTOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:14:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wsDgD5AsAeMZAGjRIu6M063/2L7FRMBR7xWFcUNlFCTtD1e/YcihG9shEu1Wkn8o6I
         Q5Qgia3ysDXde1QIK7uutnvHwJLMa2jxCyUqlEXZBo+IQKhGspGFUsmshImWsbPad2xS
         a0Bc3gNoDjLyBzboCxofF7OhNZ4XSjQYZiI3c=
MIME-Version: 1.0
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
Date: Wed, 4 Mar 2009 20:14:21 +0100
Message-ID: <8db1092f0903041114o767d0079s4c1626dae5335d70@mail.gmail.com>
Subject: Re: 2.6.29-rc6-git7: Reported regressions from 2.6.28
From: Maciej Rutecki <maciej.rutecki@gmail.com>
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
       Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/3 Rafael J. Wysocki <rjw@sisk.pl>:

>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12764
> Subject         : Can not ioremap virtual address for G33 hw status page
> Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> Date            : 2009-02-23 14:46 (9 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6fb88588555a18792a27f483887fe1f2af5f9c9b
> References      : http://marc.info/?l=linux-kernel&m=123540053219505&w=4

Problem seems by solved in 2.6.29-rc7

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
