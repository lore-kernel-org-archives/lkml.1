Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZBAMqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZBAMqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 07:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZBAMqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 07:46:04 -0500
Received: from web25803.mail.ukl.yahoo.com ([217.12.10.188]:38069 "HELO
	web25803.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752301AbZBAMqD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 07:46:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=o7y/wxo2ro45Fg6+gR8zx931ptUou9MSebjmqjLboA/42wGAw6H6/7ZOCEdHCYslmBNTv4HjhNL5mEhcEAlFVUgfyoGdSe6S8Wv6n2l4gG//SOQiv03ZDrz39MVODAdd6PlDPb/XmjyIsHERSmHONdtkeFS65ZJVKjSdL+iRu9o=;
X-YMail-OSG: hjojkuoVM1nek0_ui1n_ez1FYVTnRS1kzxNkQokmrFHR0_vklwSKcQDCLrxu8agqDsw3EJLzHH4uEQXraCh2kXzzlxLFt0D1Hk9KOq_KPEI3QQt.iHokyRyUNMjZtNcmv4zYUPmLlRzBe69S3rx_pPgIL0LZNH3_rUNHEI_LV6klqAbiNsa0Tou0m77jxtBLN5l4S.QrZrr7tO3Gab_qsoCo7Z3EyzG2
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
References: <54747.12003.qm@web25801.mail.ukl.yahoo.com> <871vul3g14.fsf@devron.myhome.or.jp> <49822E2A.3020601@zytor.com> <957266.96237.qm@web25805.mail.ukl.yahoo.com> <87bptp1njj.fsf@devron.myhome.or.jp> <87bptouoid.fsf@devron.myhome.or.jp>
Date: Sun, 1 Feb 2009 12:46:00 +0000 (GMT)
From: A B <spinflipper4@yahoo.co.uk>
Subject: Re: Fat64 / exFat fs and Linux
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <473359.26476.qm@web25803.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I've updated the tarballs to fix the bug he found. If someone tried old
> tarballs, please download new tarballs and try.
> 
>     http://userweb.kernel.org/~hirofumi/exfat/exfat.tar.gz
> 
> Thanks.
> -- 
> OGAWA Hirofumi 

I have tried the updates and it fixes all the problems I found initially.
I tried it on a larger volume as well with files >4GB ('messed up' by copying
many large files to it on XP at the same time) and it works well. (File
integrity checked using md5sum).

I would like to see this exfat read-only driver included in a future linux kernel.

Thanks again for the replies and the prompt fixes!
Cheers,
Max



      
