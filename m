Return-Path: <linux-kernel-owner+w=401wt.eu-S1030237AbXD1IKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbXD1IKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031123AbXD1IKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:10:34 -0400
Received: from web36709.mail.mud.yahoo.com ([209.191.85.43]:29783 "HELO
	web36709.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030237AbXD1IKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:10:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=GSacKcfbEo0i1JP8YwGOAtZEaPOYR3eir6R8t6CpAXlNyZWJOSaGKsUkXwKVGPKsf3XG5jxIdY3W1f3WTIaHek/vrNUZ5bhOPo6YMHszfQSc9It/Rgq4jYChLVldH9zyilWiJabNlCXvbEkgprzW6YoGQdHUuTU/awATHnjMHLI=  ;
Message-ID: <20070428081032.1003.qmail@web36709.mail.mud.yahoo.com>
X-YMail-OSG: Jlgpt4MVM1kKSmnq_QAavkzHVUUnPZ2DnrGrh72eiCvLyCIQRwHq_IoMz8P8Q..gM1Si5AaKtvpPp38kCma.S.RdJBWXL8IprK3JdQs2lHemR2FV2wGHyndwWv8auQ--
Date: Sat, 28 Apr 2007 01:10:31 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
To: Sergey Yanovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <463242AC.5050608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> After [tifm_sd] is loaded. My smoke test script at
> 
> http://bugzilla.kernel.org/attachment.cgi?id=11240&action=view
> 
> reliably hangs suspend.
> 
What is "modprobe tifm"? What modules have you loaded when it hangs?


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
