Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbXEYHr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbXEYHr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXEYHrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:47:22 -0400
Received: from m12-13.163.com ([220.181.12.13]:58135 "HELO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750898AbXEYHrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:47:21 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 03:47:21 EDT
Subject: Re: 2.6.17-rc6 No volume groups found
From: freegnu <freegnu@163.com>
Reply-To: freegnu@163.com
To: Barry Scott <barry.scott@onelan.co.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4491540A.6050806@onelan.co.uk>
References: <4491540A.6050806@onelan.co.uk>
Content-Type: text/plain
Organization: gnu
Date: Thu, 24 May 2007 23:33:04 +0800
Message-Id: <1180020784.9086.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
X-Coremail-Antispam: 1U3Yxn0WfASr-VFAUDIcSsGvfJTRUUUjFxv7VC2z280aVAFwI
	0_Gr0_Cr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l52xGzVA2a4k0FcxF6cIjj282crylIxAI
	cVC0I7IYx2IY67AKxVWUJVWUCwCF72vE52k0Y41lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMxkIecxEwVAFwVW8CwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UM7AC8VAFwI0_
	Jr0_Gr1lYx0E2Ix0cI8IcVAFwI0_JrI_Jryl7I0Y6sxI4wAYFVCjjxCrM7CIcVAFz4kK6r
	1j6r18Mc02F40EFcxC0VAKzVAqx4xG6I80ewCY1Ik26cxK64kmj7kG620IrwCY1Ik26cxK
	6xAEc7vF620IrwCY1Ik26cxK620vw7xCY7Wlb7Iv0xC_KF7anT9S1TB71UUUUU7a7-sFnT
	9fnUUI43ZEXa7IUo8-BtUUUUUFnT9fnsW5pF1UJFyUtFyDWw45ArWkXF17toXrpFWktoWI
	vr48Zw12qw15KFWrGw4kCa9xW3Z0gr1fXr1jqr4rW3WkXF9xGay5Ca4v9rWfZ3Wa93ykZa
	srury7Gwsxtayf=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i have the same problem when i built kernel 2.6.14.
and the previous working kernel is 2.6.11 form Fedora Code 4

anyone give me any adviece? thanks


On Thu, 2006-06-15 at 13:35 +0100, Barry Scott wrote:
> On my HP dc7600U having patch around the MCG problem
> I now get a bit further. Previous working kernel was 2.6.16
> from Fedora Code 4.
> 
> I see:
> 
> Uncompressing Linux... Ok, botinh the kernel.
> Red Hat nash version 4.2.15 starting
>   Reading all physical volumes.  This may take a while...
>   No volume groups found
>   Unable to find volume group "VolGroup00"
> ERROR: /bin/lvm exited abnormally with value 5 ! (pid 351)
> 
> Then a few more errors and Kernel panic
> 
> Where would the problem be?
> 
> Barry
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


