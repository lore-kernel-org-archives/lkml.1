Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYCULoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYCULoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYCULoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:44:46 -0400
Received: from web33108.mail.mud.yahoo.com ([209.191.69.138]:20113 "HELO
	web33108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752305AbYCULoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:44:46 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2008 07:44:45 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=n2f7+KjRQ6P0QmHRNJxQgGZVHSVs/WBx9vO6YacjP7VoO6gCfTxFweZo8LuT5ga6j/vXvYRVh6ZQv9OWw/xKOnbybDFYyHo9+1LSeJA5o2fL22eMixG5Ns5J9sqplJy8tNRxdL7lv9JLRuQQmnzjdpGAXRZq8T87ZMME7Op/9Iw=;
X-YMail-OSG: pSXWAhcVM1mGqpko2p6AJZFAzp9KhIidObz.Ve.Hc6PFtTBZkLEurWg8EKYo3xW_lnPAGs9V.vYIutMd1vTwBL8Bq6io2L0nUbJMqwMu6PoyJQIgos8-
Date: Fri, 21 Mar 2008 04:38:04 -0700 (PDT)
From: Rogier Stam <r_stam3108@yahoo.com>
Subject: [MMC Stack] Partition limitation question
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <904538.60285.qm@web33108.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had a short question about the limitation of max. 8
partitions in the MMC stack. Before the kernel was
limited to 256 minor numbers, but I believe this is no
longer the case (65536 if I recall correctly). Is
there a way around this 8 partition limitation?

I understand that simply renumbering all minor numbers
is not really a preferred situation as it would
require everyone to recreate their device nodes.

Regards,

Rogier


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
