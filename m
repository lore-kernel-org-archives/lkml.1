Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbXIYWHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbXIYWHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXIYWHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:07:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:6648 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbXIYWHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PWT3GzEQVNJtvMkd57e9mHjrKa7/GVpUcncOz7Ck6BpybBFQe+4P/H1xOnev29a1PAt8bO7CLp3lGHycs6Xfn/rf4k+j72WXAOGKRqaWxI6QbqLO0f0K2IEC7Y4/ePiDup6/H1VVtr+DsQsuOSyywFsDT/RAZIro5BGbYEr+zl8=
Message-ID: <46F9869D.60401@gmail.com>
Date: Tue, 25 Sep 2007 16:07:25 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F8665A.4000206@garzik.org> <46F9617F.1010508@gmail.com> <46F97257.3020502@garzik.org>
In-Reply-To: <46F97257.3020502@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Can you tell me something about this device?
> 
> [   49.045635] ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133
> [   49.051677] ata2.00: 640 sectors, multi 1: LBA
> [   49.056321] ata2.00: configured for UDMA/133
> 
> It seems like it does not support the 'check power mode' command.
> 
> Can you post a text file attachment, containing the output of 'hdparm
> --Istdout' ?

No problem.  The device in question is a Western Digital Raptor WD360GD
36.7GB 10,000 RPM Serial ATA150 Hard Drive.

hdparm output attached.

Berck
