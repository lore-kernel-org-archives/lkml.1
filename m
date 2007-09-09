Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbXIILSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbXIILSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 07:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbXIILRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 07:17:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:58547 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbXIILRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 07:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=eO3/lMdx1v/xhaWILp3kNkvdHa9UOU1T8ujoOfYzSUx4SAES//k9xCidnw2vf1bB2s9e52eO3A8ZghteKZ/dJowaKVXRgztUcbVX03CvO7NPe2CHLCi/HT7Dx2E12CD+7srIsnozt++KryqWW4ybQ21BDRgd1agldcUGDIws/5I=
Message-ID: <46E3D658.5020201@gmail.com>
Date: Sun, 09 Sep 2007 13:17:44 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: libata not working for sis5533
References: <46D132C5.5000803@gmail.com> <6bffcb0e0708261627s12e5a9acqef92d0261264a40c@mail.gmail.com> <46D8921E.3010304@gmail.com> <46D89429.7080802@gmail.com> <20070902114032.7dbfb21a@the-village.bc.nu> <Pine.LNX.4.64.0709031957390.24179@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709061156220.25942@fbirervta.pbzchgretzou.qr> <46E26DAF.9020906@gmail.com> <Pine.LNX.4.64.0709081243050.25942@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709081243050.25942@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt ha scritto:
> On Sep 8 2007 11:38, Patrizio Bassi wrote:
>   
>> Jan Engelhardt wrote:
>>     
>>> I shall give this a spin too, since I happen to have sis5513.
>>>
>>> Just booted this fresh ata-enabled system (a matter of mkinitrd). It has 
>>> not exploded yet.
>>>       
>> don't you have the "irq 14" issue?
>>     
>
> No, does not seem so.
>
>   
>> can you post here your .config?
>>     
>
> http://rafb.net/p/vfTX0966.html
>
> Maybe it is solved in 2.6.22.3? (I don't remember what your version 
> was.)
>
>
> 	Jan
>   

For Alan, libata devs...hope can help debug...
this is http://www.patriziobassi.it/downloads/libata_issue.jpg

and this is the relative config i'm using
http://www.patriziobassi.it/downloads/config

Let me know

Patrizio
