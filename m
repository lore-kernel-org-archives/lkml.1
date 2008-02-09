Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYBIHdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYBIHdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 02:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYBIHc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 02:32:57 -0500
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:20877 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751476AbYBIHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 02:32:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=ii51dysIVjSOMx7UGVUy4QhjhzAahIHjT4DZjyICSaw5hwWxv2qif/tKexGGpiH2TWLWTciFVGnRJ/CwhEkUNVFeHCfpwXAqA1IQVodjwxK3SE+mIH8ysewcgxImBqUSk/ZeYbUIV7+8qoKhQ2EzzRsPcnjHnf2FMGsz7g3JJ/g=;
X-YMail-OSG: udNlXNwVM1l.O.tiZF36kZuxtx48AodNahpwyN4wJfwjvYAkyFJO0Ha8UaQrTL7NLSXmMQ--
X-Mailer: YahooMailWebService/0.7.162
Date: Fri, 8 Feb 2008 23:32:55 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: Integration of SCST in the mainstream Linux kernel
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ming Zhang <blackmagic02881@gmail.com>
In-Reply-To: <47AC2FA7.7020700@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <462600.51623.qm@web31810.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 2/8/08, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> > Is there an open iSCSI Target implementation which
> does NOT
> > issue commands to sub-target devices via the SCSI
> mid-layer, but
> > bypasses it completely?
> 
> What do you mean? To call directly low level backstorage
> SCSI drivers 
> queuecommand() routine? What are advantages of it?

Yes, that's what I meant.  Just curious.

Thanks,
   Luben

