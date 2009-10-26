Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZJZWZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZJZWZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZJZWZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:25:23 -0400
Received: from smtp123.mail.ukl.yahoo.com ([77.238.184.54]:31737 "HELO
	smtp123.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754108AbZJZWZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:25:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=IQC93FQ7MSQZ15xnR5yi0OHnzwh1SS6ClkaNlDGcxU/eGhJTC223KkL1S46CfCSo/p3+FUdKQLqpMPNZ9ooJOlW5uyJI/OmEvPRSzxHcX/mzn6LBbVH0zGQgFhMoP37PhNCCyaGbpfR+BAxQBocPGVkGUGgBQg6ho5u6F8FujNE=  ;
X-Yahoo-SMTP: dGJefyiswBAq8gjvkVdDD_Aeiz1oX_mV
X-YMail-OSG: ViEwG9AVM1mn0YARbaHLSm_n1vJh5GZVGzUKG_TgIq0BXTb4laaNnbtDSGM74nIT.Npwf7dtsAqOg5dJpuplMqdrqaeNCrXB.96K25SYQHHkeG1HWDP8KmcVoWroT18HnesRdsMy0PWPEFjkP8tipBMY2fA_GdOIP0hXRktLnpIZymQ1d.Mo2NpqCvdZ0iNe4ckSHYlpKPjYYFoAyz8IozqYQouL6udKNDWW3KXtKjAE4uNrgu8OFSg6qx9lICXj29zY8e0ot0TqTj.toEAso5k020w5Okrm6cwSGUJDkVjdl5RLYRfOhAjThXDI7ginMVZP
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AE621CB.6000700@yahoo.co.uk>
Date: Tue, 27 Oct 2009 00:25:15 +0200
From: Boyan <btanastasov@yahoo.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?UTF-8?B?IkZyw6lkw6lyaWMgTC4gVy4gTWV1bmllciI=?= 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera> <vX3ILojF2dJ.A.lYG.ref5KB@chimera>
In-Reply-To: <vX3ILojF2dJ.A.lYG.ref5KB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14388
> Subject		: keyboard under X with 2.6.31
> Submitter	: Frédéric L. W. Meunier <fredlwm@gmail.com>
> Date		: 2009-10-07 20:19 (20 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
> References	: http://marc.info/?l=linux-kernel&m=125494753228217&w=4
> 

I think it is fixed in 2.6.31.5. I can't reproduce the problem with it.
