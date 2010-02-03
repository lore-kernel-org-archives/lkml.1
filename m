Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab0BCBXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 20:23:11 -0500
Received: from web50203.mail.re2.yahoo.com ([206.190.38.44]:29701 "HELO
	web50203.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753924Ab0BCBXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 20:23:08 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 20:23:07 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=jhNmgmST3y76crV1gq/bgwjrhaKNtwZwe7zyOJHddHkx3mVVRm1HKwAuum7BjSMFTlkZEXeWCjT1W0kcEuJMz285Ajm4Abe/aoi8wq2TJA82ckT743pEDZZbD2W45bV+kinuhBu/isSqD2mATBNsf6xvBYvx8tLpW2eFdXc0Tn0=;
Message-ID: <244199.71589.qm@web50203.mail.re2.yahoo.com>
X-YMail-OSG: XI7s26gVM1l33uNzGnVvlkBKLArKPR.hVPzw_ocyCoEhD_.9Zwu63bq2QtkSDJoLCOa07swmX4pv51N0dShFsiqKf4Wztgmeye5bW.MMltUh6bFQJ_Q2TEFJ_2VOrCTe4iKvCt5QRFC6IIVEQevZzOnwKpp.DFfN2J5_5H7PPz.XLHd4yFeS2HDLEJKmAkq2vpZkdKtijvhqozoHNXAs5d9J0XWgkcMMrytrNi7S13RwVJPE76CVcNkW9aZU7cjNUsslR2wJUzcdQCXurSVCwSsGZx9N7igcrcUlBKQsBzIHEYHq.0jKixK4hg--
X-Mailer: YahooMailClassic/9.1.10 YahooMailWebService/0.8.100.260964
Date: Tue, 2 Feb 2010 17:16:26 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Phoronix test
To: tytso@mit.edu, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tytso said:
>Of course, if the crappy proprietary video driver from ATI (or Nvidia)
>scribbled garbage over cached inode tables which were then written
>back to disk, there's not much anyone can do about it, no matter what
>file system they were running.

According to the story, Phoronix were using the open source ATI drivers
for all testing.


I code, therefore I am


      
