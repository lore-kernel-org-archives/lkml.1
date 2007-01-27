Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbXA0OnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbXA0OnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 09:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXA0OnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 09:43:13 -0500
Received: from oola.is.scarlet.be ([193.74.71.23]:47531 "EHLO
	oola.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbXA0OnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 09:43:12 -0500
Message-ID: <45BB64F1.1000105@scarlet.be>
Date: Sat, 27 Jan 2007 14:42:57 +0000
From: Joel Soete <soete.joel@scarlet.be>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@redhat.com>,
       Ioan Ionita <opslynx@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com>	 <20061116235048.3cd91beb@localhost.localdomain>	 <df47b87a0611161730p70e1dd41iad7d27a0bf9283ff@mail.gmail.com>	 <df47b87a0611161734h818fc4dneaad5eeaa7e3c392@mail.gmail.com>	 <20061117100559.GA10275@devserv.devel.redhat.com>	 <459286C2.7080705@scarlet.be> <45943C15.4010506@scarlet.be>	 <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be>	 <45BB51F9.5070100@scarlet.be> <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com>
In-Reply-To: <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020009080100060708010603"
X-DCC-scarlet.be-Metrics: oola 20001; Body=8 Fuz1=8 Fuz2=8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020009080100060708010603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Luming Yu wrote:
> Does acpi=off make cdrom work?
> 
Unfortunately not :_(

(for more details I attached a compressed dmesg trace?)

Thanks,
	Joel

> On 1/27/07, Joel Soete <soete.joel@scarlet.be> wrote:
>> Hello all,
>>
>> I just tested libata with this newest 2.6.20-rc6 but no changes ;-(
>>
>> Any news?
>>
>> Thanks,
>>         Joel
>>

--------------020009080100060708010603
Content-Type: application/x-gzip;
 name="DmesgPata5.doc.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="DmesgPata5.doc.gz"

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
HbKhhEaFQKEY7f8AllCI9dE7AAA=
--------------020009080100060708010603--
