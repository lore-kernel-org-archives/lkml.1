Return-Path: <linux-kernel-owner+w=401wt.eu-S932505AbZLFNGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbZLFNGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 08:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236AbZLFNGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 08:06:05 -0500
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:41083 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932107AbZLFNGF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 08:06:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=KFD4BZkH48hA1ULmeD/5wdfY9MBqfdHuzvuVejtm6+VikgRdw8P+c7tkxdaen4Jmmgze3HMSWF5mho1GSCOMEhRqeLs62DdCgURnifzUr51vZtgyvGQ7TP2ZwEQAWVUwcFXmEMKrGDixPsqYMHB0mJIWF9pblxcXc9BdWZUZufU=;
Message-ID: <673993.29322.qm@web52901.mail.re2.yahoo.com>
X-YMail-OSG: Jy0rdw8VM1nQRIUy5O_xjNgMxoMk.NbC9uNHu1XegurQkNNrs2a6Vr4J9Z9H1lzE32Ty6eXEweu8L6B10vvsv939_FX.G9Rw_Zoz2MCk8PWm7aRbjZJdWl2Tax0Dtss8kMs1tPMWN4tlrMYNCYqB64I2A8eBoiq5CGhgmkda1N8XQXySAoKrp3PzHIYXErKn.A6fgFqpRe7kMA8.MiBpJK5rkUWxAnfFNh8MoGsS14jTLJ79IW4vk63RlHt7V7MbAHNLGWz4Htz5vBR16hcu8J_XZgm71RiBUHgPRfLs4NK8DBiSuVRBk4mQLMpA686sd33i_IT2wJl4fdVYELyOYQ--
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.8.100.260964
Date: Sun, 6 Dec 2009 05:06:10 -0800 (PST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [WARNING] Network-related warnings with 2.6.31.6
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried applying the sunrpc/UDP patch you suggested, just in case that bug was scribbling into memory somewhere. However, I still had a complete PC freeze last night during a period of heavy surfing so I suspect there's a nasty network-related bug in 2.6.31.x somewhere.

Is there anything else in the -stable queue that might help, please? Come to think of it, it's been almost a *month* since the last -stable patch. Has 2.6.31.x been "wound down" already in favour of 2.6.32.x?

Cheers,
Chris


      
