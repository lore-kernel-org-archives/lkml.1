Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbYH0AoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbYH0AoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 20:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYH0AoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 20:44:13 -0400
Received: from web33206.mail.mud.yahoo.com ([209.191.69.154]:20561 "HELO
	web33206.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752586AbYH0AoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 20:44:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=PRmtoXp3sIAonL06SThczEDolaLCmyGwXqiMPp9/hJF/IkLcFQt6IBLwd+Or1roNWLlkGT7rH+fgMLJ9DCSh9B2AGVQPn07U5GOHsrd0LYDcWJlGGapoHJi1GOXlllEQ2ALNrHTO/cmlCBuMCh1wuliE2qOOTc51ZsQxafsfzP4=;
X-YMail-OSG: jaU2A2YVM1kncIeZgXSAcb1ihUlFBONhLLVBOflgJ3FXIEL6_ZJJI3T2TINOceMplw--
X-Mailer: YahooMailRC/1042.48 YahooMailWebService/0.7.218.2
Date: Tue, 26 Aug 2008 17:44:12 -0700 (PDT)
From: jassi brar <jassi_singh_brar@yahoo.com>
Subject: Re: An idea .... with code
To: linux-kernel@vger.kernel.org
Cc: jochen.voss@googlemail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <215864.42566.qm@web33206.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jochen, Marcin and Bill,

> Some minor remarks below.
> It's better to check this patch with scripts/checkpatch.pl  
Thanks for the feedback. I admit the code is not near perfection, but then 
 i think that comes after the community finds the idea any worth.

> will it interface with crypto applications like LUKS? 
   It should work with LUKS, as it transparently emulates a file as a block device. 
 Please suggest a test case(webpage?) to verify it against LUKS, as i don't know much about it.

 As i said the code was just as a proof of concept hastily put together. I heard Linux folks hate Ideas without code :)
 Btw, i personally believe not everyone with an idea could code well and not every good programmer is as well creative.
 
Regards,
-Jassi


      
