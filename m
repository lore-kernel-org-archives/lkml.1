Return-Path: <linux-kernel-owner+w=401wt.eu-S937087AbYECAoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937087AbYECAoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 20:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765206AbYECAoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 20:44:24 -0400
Received: from web50201.mail.re2.yahoo.com ([206.190.38.42]:23319 "HELO
	web50201.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764994AbYECAoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 20:44:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=tAbJyyFGTCp319e5mosw8ch31goaaUCrT8Qwz4iA8SlH+NNoS2a/XmC+f2z/NxTHompD8sV7c2SXkhhoIt0Fpdy+OkGjjiPykUrlv06qD6EYdpPbm6h30L2Twdisoakg2EsUPdIKAlIrMuTb2SCTycFI3in+s4JymqjoQRM68PM=;
X-YMail-OSG: bLQ_XCYVM1mjlWUElGY9G9DXR_q_2_rEJK2Ht5hkbsPoELGIlDAEISYv8Ptq9UXiOFvitROay9zgGrdR._9kVz4T5LkjgVkpm8mHh.B_C6XBUfUQgBcNrw--
X-Mailer: YahooMailWebService/0.7.185
Date: Fri, 2 May 2008 17:44:18 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: alex14641@yahoo.com
Subject: RE: Sharing disks amoung multiple software RAIDs
To: Kasper Sandberg <lkml@metanurb.dk>, David Greaves <david@dgreaves.com>,
       David Lethe <david@santools.com>
Cc: David Rees <drees76@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <A20315AE59B5C34585629E258D76A97C335960@34093-C3-EVS3.exchange.rackspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <824925.21830.qm@web50201.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I code, therefore I am


--- On Fri, 5/2/08, David Lethe <david@santools.com> wrote:
[snipped]
> I was being too literal. md is a good solution (I use it
> myself).  However, the OP wanted to "Make sure that if
> one disk dies, the data is still in tact".  
I was also concerned about performance. It seems that if the RAIDs will 
be used heavily and independent of each other, and performance is a 
concern, then dedicated disks (and possibly dedicated controllers)
are the better option.


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
