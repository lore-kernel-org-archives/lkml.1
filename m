Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbYCYXUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbYCYXUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYCYXUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:20:45 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:25287 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754614AbYCYXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:20:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=qexdEjwPGZ65Bjca9wfifd6EPLR6ksOPitbK15554lHORYmfIumA3chAyLQMnYRRP/mYuvAMg5DaARJ1V/wj5jxSqc1mSQjmE0Dh7zOMZOulvCNh8b8rCLuBelI7bL1dT0KtUDi1cX+pJpdKKgyY2/Qf9K5MKsMmz1NIQ5pwrPk=  ;
X-YMail-OSG: 9XJ_pDoVM1m9JDdZXTK77tvh48EwDhEBty.ssclRaD3Ay8vyc.OJJYeM..HB2uyfAonHUO3xTXYv0SyzD1Dwpm3HA70ZxIm8PpKYhDUci_rRcU9WfA--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 25 Mar 2008 16:20:42 -0700
From: David Brownell <david-b@pacbell.net>
To: rpurdie@rpsys.net
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Cc: gitster@pobox.com, corbet@lwn.net, stern@rowland.harvard.edu,
       mingo@elte.hu, mb@bu3sch.de, linux-kernel@vger.kernel.org,
       khali@linux-fr.org, hmh@hmh.eng.br, geert@linux-m68k.org,
       akpm@linux-foundation.org
References: <14605.1206452655@vena.lwn.net>
In-Reply-To: <14605.1206452655@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080325232042.4EDA7346532@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I _almost_ hate bringing this lovely flamage back onto $SUBJECT ... but
what's the resolution for the leds-gpio.c issue?  I've not seen a merge
notice for the patch I submitted a week ago now:

	http://marc.info/?l=linux-kernel&m=120597839009399&w=2

Just a "leaning..." comment:

	http://marc.info/?l=linux-kernel&m=120606104619198&w=2

Seems to me that by now there ought to be resolution on at least
one of the issues brought up on this thread.  :)

- Dave

