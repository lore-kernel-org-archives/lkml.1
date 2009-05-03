Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbZECUtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbZECUtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZECUtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:49:35 -0400
Received: from outbound-mail-132.bluehost.com ([67.222.39.22]:60416 "HELO
	outbound-mail-132.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753466AbZECUte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:49:34 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 May 2009 16:49:34 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=damore.org;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oOpobC/gBPL2e1jizDhUXqfYigk+rLO0RvCN8fDlDfCXpf7jOva3XV32q8qiHLaFMJVUShukdHY7OoaAFL1OT4cPhPYiN5XTVAspRAaWlzb/+g4FGuJFtWEi5vj0GMIW;
Message-ID: <49FE01CD.8000903@damore.org>
Date: Sun, 03 May 2009 13:42:53 -0700
From: "Garrett D'Amore" <garrett@damore.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081201)
MIME-Version: 1.0
To: Pierre Ossman <pierre@ossman.eu>
CC: linux-kernel <linux-kernel@vger.kernel.org>, sdhci-devel@lists.ossman.eu,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [Sdhci-devel] SDHCI driver runnining in aspire one, allows to
 write to R/O SD cards
References: <1240219764.13640.5.camel@maxim-laptop>	<49ED0865.9030603@gmail.com>	<1240524632.20871.0.camel@maxim-laptop>	<1240759276.10972.0.camel@maxim-laptop>	<49F5F57D.3010700@damore.org> <20090503212944.214d7137@mjolnir.ossman.eu>
In-Reply-To: <20090503212944.214d7137@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2225:box374.bluehost.com:damoreor:damore.org} {sentby:smtp auth 192.18.43.225 authed with garrett+damore.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Mon, 27 Apr 2009 11:12:13 -0700
> Garrett D'Amore <garrett@damore.org> wrote:
>
>   
>> As an extra data point, my sdhost driver in OpenSolaris works fine on 
>> the AA1.. it does see that the cards are locked, and refuses to allow 
>> them to be mounted read/write.
>>
>> This leads me to believe that the original linux problem is one of two 
>> things:
>>
>> * either a bug in the linux code, or
>> * busted circuit/hardware on a specific unit (i.e. a damaged unit)
>>
>>     
>
> I don't suppose you could try a Linux LiveCD to determine if your AA1
> has the same issue under Linux?
>   

I'll have to download one, and I need to install via USB media... (which 
I've not done with Linux before) -- the AA1 doesn't have a CDROM drive.

    - Garrett
> Rgds
>   
> ------------------------------------------------------------------------
>
> _______________________________________________
> sdhci-devel mailing list
> sdhci-devel@lists.ossman.eu
> http://list.drzeus.cx/mailman/listinfo/sdhci-devel
>   

