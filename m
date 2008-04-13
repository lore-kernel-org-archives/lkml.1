Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbYDMWZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbYDMWZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYDMWZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:25:43 -0400
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:47096 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbYDMWZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:25:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=YpA9fvZWj4zXZOwFUjw8BaNVioPi5Oth9QgIEQ+ZM2P/9cG2KPABRno61fABKbyU;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <48028830.6020703@earthlink.net>
Date: Sun, 13 Apr 2008 18:24:48 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       Tilman Schmidt <tilman@imap.cc>, Valdis.Kletnieks@vt.edu,
       Mark Lord <lkml@rtr.ca>, David Miller <davem@davemloft.net>,
       jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Reporting bugs and bisection
References: <47FEADCB.7070104@rtr.ca> <20080413121831.d89dd424.akpm@linux-foundation.org> <20080413202118.GA29658@2ka.mipt.ru> <200804132233.50491.rjw@sisk.pl> <20080413205406.GA9190@2ka.mipt.ru>
In-Reply-To: <20080413205406.GA9190@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79c62e61511a8d0fa45cc246f9d24c3f7c350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 24.144.77.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Sun, Apr 13, 2008 at 10:33:49PM +0200, Rafael J. Wysocki (rjw@sisk.pl) wrote:
>> Things like this are very disappointing and have a very negative impact on bug
>> reporters.  We should do our best to avoid them.
> 
> Shit happens. This is a matter of either bug report or those who were in
> the copy list. There are different people and different situations, in
> which they do not reply.
> 
Well less shit would happen if developers would take the time to at least test 
their patches before they were submitted. It like we will just have the poor 
user do our testing for us. What kind of testing do developers do. I been a 
linux user and have followed the LKML for a number of years and have yet to see
any test plans for any submitted patches.

My $.02
Steve Clark

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


