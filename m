Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0BKTv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:51:58 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47930 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab0BKTv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:51:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=hFK5F2IktFmlxn9UjpQhODqS/61GIXwyUn+GXLoW45Sua63zhmQgCb5X5VXy5tCx6E
         2xkXY7wgDyTckdR+oYvxG37lVw/5zeY1zdwcSkQPdayJlVNqfa2sZtVDhXAG2f0LqoF9
         pprlMOPU65e45blczISFXsUBYB60kozaToSEk=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: davidsen@tmr.com
Subject: Re: 2.6.33-rc6 crashes on resume
Date: Thu, 11 Feb 2010 20:51:52 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4B70982F.8090208@roadwarrior3.tmr.com>
In-Reply-To: <4B70982F.8090208@roadwarrior3.tmr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002112051.52060.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia wtorek, 9 lutego 2010 o 00:03:11 Bill Davidsen napisał(a):
> Pretty simple to reproduce, boot, suspend, press shift
> 
> Acer Aspire 1681, Celeron, 2.6.33-rc6. Trace and config attached.
> 

I created a Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15277
for your bug report, please add your address to the CC list in there, thanks!

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
