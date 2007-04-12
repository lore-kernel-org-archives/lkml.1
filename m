Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbXDLMtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbXDLMtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 08:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbXDLMtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 08:49:13 -0400
Received: from web52907.mail.re2.yahoo.com ([206.190.49.17]:47421 "HELO
	web52907.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753665AbXDLMtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 08:49:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=u0Wcrc9RIdin7dqXFeQL0tqzuNzxa4LhA5kn9A48OQ5rdKyfBL1DR7hvNfr2hWN4WKCQNC4fE/QdJ3Ho/KdTnQQ9GQ9DhDBZpPz3tLwS3BNxtxVJLczjpw7yJ6LGzPLTHifsXyCy67izmXKrrhMzf1XIu8ZiAl5FxxapPK88hz4=  ;
Message-ID: <20070412124910.47686.qmail@web52907.mail.re2.yahoo.com>
X-YMail-OSG: 9QztG.YVM1kVNCet83nZ8DiSMy0FzRnPoeSEFgGzhjDm9NwDKwMIu8u.B8T6N8aHUyQic3M40taWM7vrrrx22QA4.fulD58qW.2wfK1ARixPrbN12ca1k0HttKq4kQ--
Date: Thu, 12 Apr 2007 13:49:10 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [new 2.6.21-rc6 crash] BUG: unable to handle kernel paging request at virtual address 6b6b6ceb
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, THAT looks familiar...

http://bugzilla.kernel.org/show_bug.cgi?id=8198

Yes, it is in 2.6.20.x.

Cheers,
Chris



      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/ 
