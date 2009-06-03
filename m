Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZFCR1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZFCR1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZFCR0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:26:52 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:40836 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZFCR0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=utiiFtPqEMIaJoyo1vxRvkJz8Fsw4HSIORnkbsXzR7v6gWwNDDyRpifaFrjiMLrX2c
         rwkslYh2f+grymZmaS1mij82gYvSbB/aYYPFbUq9GgM4beSfoFErZYdimvW2iIshGv4N
         wfAXux3QgTIpGxOgTtO6JV9HmSTsidTPdOdmk=
MIME-Version: 1.0
In-Reply-To: <1244040123.6938.19.camel@o>
References: <18980.48553.328662.80987@notabene.brown>
	 <4A25876A.1010901@garzik.org>
	 <18981.62579.171350.910761@notabene.brown>
	 <1244040123.6938.19.camel@o>
Date: Wed, 3 Jun 2009 10:26:51 -0700
X-Google-Sender-Auth: 2234eb17fce5349d
Message-ID: <e9c3a7c20906031026s49a5a694hb91db40dc05a2580@mail.gmail.com>
Subject: Re: [dm-devel] Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft 
	RAID under Linux
From: Dan Williams <dan.j.williams@intel.com>
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Ed Ciechanowski <ed.ciechanowski@intel.com>,
       Jacek Danecki <jacek.danecki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 7:42 AM, Heinz Mauelshagen <heinzm@redhat.com> wrote:
> On Wed, 2009-06-03 at 13:56 +1000, Neil Brown wrote:
>> As for integrating the two code bases.... people have been suggesting
>> that for years, but I suspect few of them have looked deeply at the
>> practicalities.  Apparently it was suggested at the recent "storage
>> summit".  However as the primary md and dm developers were absent, I
>> have doubts about how truly well-informed that conversation could have
>> been.
>
> Agreed, we'd need face-time and talk issues through in order to come up
> with any such plan for md+dm integration.
>

What are your general impressions of dmraid using md kernel
infrastructure for raid level support?

Thanks,
Dan
