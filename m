Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYBIHoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYBIHoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 02:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYBIHoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 02:44:12 -0500
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:45190 "HELO
	web31805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751861AbYBIHoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 02:44:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=Po/PYlusT2E9dQ55rB/x/yK1b5rEdO/Pr0QAM5xToecgOlZbrWgniiM4j7xehCAdpE6F3JmYohbgGaSCWYLRF7zJ71PzNS+4olarC+O4td5ysWrEK7CsMRj3T93/939G/8E5ObCgqgN45vTST4130SIHdD5vh3cVmsemhCHz31E=;
X-YMail-OSG: WPoguEMVM1kNshgicky3d6beBtiYYtf5OdMFI4fT2XLXd3XMNa2eQjqIdLnXm2vunG67OByBH8J4ISDjmqZ.ijC16IxseesrVQz0insj4umXdxw-
X-Mailer: YahooMailWebService/0.7.162
Date: Fri, 8 Feb 2008 23:44:10 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ming Zhang <blackmagic02881@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <152035.25571.qm@web31805.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 2/8/08, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > Is there an open iSCSI Target implementation which
> does NOT
> > issue commands to sub-target devices via the SCSI
> mid-layer, but
> > bypasses it completely?
> > 
> >    Luben
> > 
> 
> Hi Luben,
> 
> I am guessing you mean futher down the stack, which I
> don't know this to

Yes, that's what I meant.

> be the case.  Going futher up the layers is the design of
> v2.9 LIO-SE.
> There is a diagram explaining the basic concepts from a
> 10,000 foot
> level.
> 
> http://linux-iscsi.org/builds/user/nab/storage-engine-concept.pdf

Thanks!

   Luben
