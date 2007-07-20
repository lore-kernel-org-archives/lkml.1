Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbXGTLzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbXGTLzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbXGTLzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:55:45 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:57662 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbXGTLzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:55:44 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <200707201429.54241.a1426z@gawab.com>
References: <200707200813.03553.a1426z@gawab.com> <aa4c40ff0707192225r6b5e971fy59f78a525697f864@mail.gmail.com> <200707201429.54241.a1426z@gawab.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <F862477F-F191-4971-A479-5EEA598FEC62@cam.ac.uk>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFH] Partition table recovery
Date: Fri, 20 Jul 2007 12:53:42 +0100
To: Al Boldi <a1426z@gawab.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Jul 2007, at 12:29, Al Boldi wrote:
> Anton Altaparmakov wrote:
>> parted and its derivatives are pile of crap...  They cause corruption
>> to totally healthy systems at the best of times.  Don't go near them.
>>
>> Use TestDisk (http://www.cgsecurity.org/wiki/TestDisk) and be happy.
>> (-:
>
> This one really worked best, without getting confused about older  
> partitions.

Yes, TestDisk is very good.

> Thanks everybody!

You are welcome.

> BTW, what's a partion table?

Are you kidding?  If not read those two and you shall be enlightened  
(or utterly confused (-;)...

http://en.wikipedia.org/wiki/Partition_(computing)
http://www.ata-atapi.com/hiwtab.htm

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


