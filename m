Return-Path: <linux-kernel-owner+w=401wt.eu-S934975AbZAOXFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975AbZAOXFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936094AbZAOXEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:04:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:25514 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936241AbZAOXEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:04:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JXN8VUU03udcxAtW2dqizszSaFHZeSxl47KIF8grsYPC7mwNoDCLIX9qXn2Axr8oJN
         CKEixqCf0WZapuWYMfC6mWC8MMWAvyL/JiqMm9gN0vOGdNLA/IvOi2muuC6tnX/DKkBd
         hhZRbCdhP3QfZr8XIAghZ//HfJgbf/s/FM30U=
Message-ID: <8db1092f0901151504h4d8f9234q4b06522149c54af4@mail.gmail.com>
Date: Fri, 16 Jan 2009 00:04:05 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: 2.6.29-rc1 does not boot
Cc: "Dieter Ries" <clip2@gmx.de>, "Ingo Molnar" <mingo@elte.hu>,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <496FB0A5.6050004@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu>
	 <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu>
	 <496A3F62.8090902@gmx.de> <496F9604.8020101@sgi.com>
	 <496FA4B6.3000607@gmx.de>
	 <8db1092f0901151348l47ffcec7m638180ca2cdbe4ce@mail.gmail.com>
	 <496FB0A5.6050004@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/15 Mike Travis <travis@sgi.com>:

>
> And it works ok without my patch?  Drats!  ;-)
>
> I'll see if I can't figure out how to debug it here.
>
> Thanks!
> Mike
>

To be clear:
2.6.29-rc1-git5:
s2disk: hang
s2ram: resume immediately and hangs

2.6.29-rc1-git5+ Your patches (3):
s2disk: works OK
s2ram: resume immediately and hangs
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
