Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbXLJBD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbXLJBD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 20:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXLJBDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 20:03:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:41655 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbXLJBDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 20:03:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=T6phgpt7MGKqd47HH8KJHNY1mR02/WhOFSxM2Lan07M8A/6EDukN8cqO2zr6uEfBNoCe7LzBU+Fsf1BZSppVXhNp8n/lGniULT2RH6vUkoln+78VxtFJ+EJ8RnZeVCQ9jzbTZbWybVmQj/KhbMFtlPPHUHGZnIfewGed0mzelec=
Message-ID: <475C906A.50503@gmail.com>
Date: Mon, 10 Dec 2007 10:03:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Kjartan Maraas <kmaraas@broadpark.no>
CC: Tomas Carnecky <tom@dbservice.com>, Pavel Machek <pavel@ucw.cz>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: laptop reboots right after hibernation
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz> <4740692E.7010801@dbservice.com> <47409DA3.7070909@dbservice.com> <1195551141.2792.3.camel@localhost.localdomain> <474CBFB6.4020105@gmail.com> <1196253340.2884.1.camel@localhost.localdomain> <474FE862.4040700@gmail.com> <1196458627.4106.1.camel@localhost.localdomain> <47565738.1050003@gmail.com> <1196874547.3700.0.camel@localhost.localdomain> <4757608D.8020005@gmail.com> <1196959657.2661.0.camel@localhost.localdomain> <475B8F51.8030605@gmail.com> <1197236609.4022.0.camel@localhost.localdomain>
In-Reply-To: <1197236609.4022.0.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kjartan Maraas wrote:
>> Hmmm... Ah.. okay.  Wrongly splitted patch.  Can you please do it one
>> more time?
>>
> Attached.

Alright, it works now but it seems both dmesgs are from no-filter patch.
 I'm pretty sure it works too because one of your previous dmesgs showed
it worked.  Please double check.

Thanks.

-- 
tejun
