Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbXFUIa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbXFUIa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 04:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXFUIaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 04:30:15 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:18953 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbXFUIaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 04:30:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CyTciPNSKs/7Z7HjPqHPtBH2gTJ3UiJkMrpkHuxEOs0+Lxh8RyEwQ3QPOB++XZPBB6cHcj8a1q3kaHQxB7INnuLAp1vHZ+UqfnCDfxvIOll7l1CsaAwROex+ksXhOCnx8ibusFCXurW/PZ0zI1jWwb3u7jWZZkHaKe+MCN1ZEMA=
Message-ID: <6bffcb0e0706210130h227dcd62n52f34e45dfd8e818@mail.gmail.com>
Date: Thu, 21 Jun 2007 10:30:11 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: =?WINDOWS-1252?Q?Re:_[ANNOUNCE]_Linux_Kernel_Tester=92s_Guide_v0.3-rc1?=
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Jarek Poplawski" <jarkao2@o2.pl>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <661de9470706210031s36396c31xff5428ff60042073@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4676E707.8020109@googlemail.com>
	 <661de9470706210031s36396c31xff5428ff60042073@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

On 21/06/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> Wonderful! Are there any plans to start using the fault injection framework
> to catch more defects?

There are plans for the second part called "debugging techniques", but
I really don't know when I'll start writing this.

In fact I don't even know if it will be useful for testers. IMHO it is
for developers not for testers.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
