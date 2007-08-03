Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbXHCKGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbXHCKGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 06:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758571AbXHCKGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 06:06:15 -0400
Received: from web26709.mail.ukl.yahoo.com ([217.146.176.72]:38986 "HELO
	web26709.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758324AbXHCKGP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 06:06:15 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Aug 2007 06:06:14 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=gNZNQ2leEaIK4lpyo8Dy/J1txdhmmfmF1nILg1BoLeiJ5MQeYdt7EAbaDrNUuoxUFjqfX4/WAiH6tgb7JSS50/aqpQx4YMTHej703d+QJCb37OxAMH7k3vCN9yEG7xh8TORpgS485x4j/3bufxidXZqGVfJVhiWA0muZualdUAQ=;
X-YMail-OSG: zc6EsS4VM1krBBdEwNg6Og2VsAuhVsKMfgL.1WMfkcd8yjNfvdFc0BGnOOrBmkW9EElANDMtFw--
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.119
Date: Fri, 3 Aug 2007 09:59:32 +0000 (GMT)
From: gregfe <gregfe2002@yahoo.fr>
Subject: Implementation of POSIX mqueues in Linux 2.6
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <76026.87188.qm@web26709.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,
I find little documentation on the actual implementation of POSIX message queues in Linux, and need some advise. In
particular, I am wondering whether it supports inter-process *and* inter-thread
communication, and if can I manage to use shared memory pools for zero-copy messaging in case of inter-process
communication. On more thing: kernel's "make menuconfig" of version 2.6.11 says :

>> To use this feature you will also need mqueue library, available

>> from <... a URL ... to M. Wronski's and K. Benedyczak's home page>"

Is it still up to date ?

Thank you very much for your advise !

G.



      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
