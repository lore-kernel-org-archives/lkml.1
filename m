Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZFFTA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZFFTA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 15:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZFFTAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 15:00:52 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:61067 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZFFTAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 15:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=H117dtVMCcgrXTm1LESrrJEfGx3HRw8kQzMFWjtVsgn2SdNCWvdZ9zRmtHBdXU9jxZ
         rgMuESMz5E4HNCp9Zhu+q278XWOTtKU7rS0DiDCaXmkoNE2NuyEtMKLM/on+mnIXEOHz
         JLuh/1zlOdf3uUfndn6tKx69UMoR7hNYywtH0=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc8 Oops whilst booting
Date: Sat, 6 Jun 2009 19:59:55 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906061959.55592.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After a git pull earlier today, I've had oopsen whilst booting the system twice today:
A photo of the oops message can be viewed at:

http://img231.imageshack.us/img231/8931/dscn0610.jpg

I haven't used the 2.6.30-rc kernels very much, so I don't have a clue when the problem was 
introduced. I have no problems at all with 2.6.29.4.

Happy to help solve this - just let me know what else I can do.

Thanks
-- 
No, Sir; there is nothing which has yet been contrived by man, by which so much happiness is 
produced as by a good tavern or inn - Doctor Samuel Johnson
