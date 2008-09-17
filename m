Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYIQNTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYIQNTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYIQNT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:19:27 -0400
Received: from web26201.mail.ukl.yahoo.com ([217.12.10.238]:32176 "HELO
	web26201.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752266AbYIQNT1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:19:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ViXNLGXcFz2XmzeNN5bP5kbNtPq0QHW+AI2uGMaF5F4hBCq4CxmB5/9vyVKOL/le4IiaCxuHs1IcX6pk749y42u0k8qiTbcXTfAwE51FC/s83wotxblCv8RDVyGX3bLX7ijtnk7AdgOeCRbeKthg5yYeIGvywnD0V/NEY5foHXM=;
X-YMail-OSG: sCqk5NsVM1nSkZtcg5ND7eZGfh6gI4sFxz57w08OwTORpnqAD346qUjWmAMlW_KFxZzBEL7OlD9MfphBC1mJDA79_ywXA9j05S6e2s.C8aVh4J4DdqwDYaOXRKYXxsEyccfNgaYj61GAWqCJuLvNQTo-
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Wed, 17 Sep 2008 13:19:25 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
To: Martin Knoblauch <knobi@knobisoft.de>,
       linux-nfs list <linux-nfs@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <525424.91603.qm@web26201.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi



----- Messaggio originale -----
> Da: Martin Knoblauch <knobi@knobisoft.de>
> A: linux-nfs list <linux-nfs@vger.kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Inviato: Mercoledì 17 settembre 2008, 15:06:40
> Oggetto: [RFC][Resend] Make NFS-Client readahead tunable
> 
....

> diff -urp linux-2.6.27-rc6-git4/Makefile linux-2.6.27-rc6-git4-nfs_ra/Makefile
> --- linux-2.6.27-rc6-git4/Makefile      2008-09-17 11:35:56.000000000 +0200
> +++ linux-2.6.27-rc6-git4-nfs_ra/Makefile       2008-09-17 11:45:09.000000000 
> +0200
> @@ -1,7 +1,7 @@
> VERSION = 2
> PATCHLEVEL = 6
> SUBLEVEL = 27
> -EXTRAVERSION = -rc6-git4
> +EXTRAVERSION = -rc6-git4-nfs_ra
> NAME = Rotary Wombat
> 
> # *DOCUMENTATION*

I'm not an expert but maybe this is not necessary :) 

> 
> 
> Cheers
> Martin
> 
> ------------------------------------------------------

Michael

__________________________________________________
Do You Yahoo!?
Poco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e ti da tanto spazio gratuito per i tuoi file e i messaggi 
http://mail.yahoo.it 
