Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZFOHeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZFOHeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZFOHeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:34:00 -0400
Received: from web36707.mail.mud.yahoo.com ([209.191.85.41]:33145 "HELO
	web36707.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751374AbZFOHd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:33:59 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 03:33:59 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=HNLsK1uEJ2X2bj6E146X8ckLGyzyo6Bpy8N8Bvbx+9BcxbGZfo65kdmvOZE8wHqEWLE2+N0RtjJfGd1deI+gpl3FD7sj6f9PevDvApi0jG7rDiOFQNMcYdnAnHGzEJQIAPnQfTAbQRGrh13o56OpbUOBYijVoAG4LF9ZTcWE508=;
Message-ID: <801926.84487.qm@web36707.mail.mud.yahoo.com>
X-YMail-OSG: YZ6AHfMVM1kfU47jLOCqYlN3zBTypUBki4boPwlewgLtBshrHKJaCfFchBODgq4dmYmGvehvn_4yZZ0mFZjzCTvaGF5qq3PISa3HeNW2IRNMZy_zoUbfnSlRso9WOaoTBpDknGzRqzSdE85YnSfYYAC7MwEgwexSdX2NJU1EvVFTdeGPujLxDjHL.SYLYENdTiix.2CJEnRSGkjo_UHPZgFFcsEdAx52ZCAxtSWjcIMwwsBsQoc7YTGj.eOY66SHf7c0W.UXijUYV_JLHbz3Gd8mCIDa_aWnysPkfcn0OnPGeVOvk9TXlqPTQs07IqBRNRV84w--
X-Mailer: YahooMailClassic/5.4.12 YahooMailWebService/0.7.289.15
Date: Mon, 15 Jun 2009 00:27:21 -0700 (PDT)
From: Jan Naceradsky <naceradsky@yahoo.com>
Subject: Re: [uClinux-dev] NIOS2 and TSE Marvell 88E1111
To: Mike Frysinger <vapier@gentoo.org>,
       uClinux development list <uclinux-dev@uclinux.org>
Cc: uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
       Jie Zhang <jie.zhang@analog.com>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,
have you somebody uClinux running on StratixIII DSP kit with TSE Marvell 88E1111 ethernet chip ? 
When i use the 
/>ifconfig eth0 hw ether 00:07:ed:ff:4a:d7
/>ifconfig eth0 192.168.1.234
/>ifconfig eth0 up
/>route add default gw 192.168.1.254
linux report - Trying 10/HALF - in this moment i don`t know what it does ?
After this when i try ping to my pc, it finish by request timeout (and tx led on board don`t blink). 
Where could be mistake ? The example of webserver work fine and simple socket server too.

Thank you.


      
