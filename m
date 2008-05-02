Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbYEBOON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbYEBOON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762885AbYEBONr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:13:47 -0400
Received: from web50210.mail.re2.yahoo.com ([206.190.38.51]:22648 "HELO
	web50210.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935163AbYEBONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:13:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=sgxfKzK0yYiUOHbFIQYpBap9rrlsxu5XyDkCsJJ+VXQxkxf8jD1GC8bBZwV925PoPOBeNXBO6jZnxrZNUGaL2N5eoGHuiTvwp5lF9+smwJIUN0YxJ8tnkBcOIGS4gZRvFGYq6gZqbOk3tm3IrOV/cnDOZGAAXIEdNp0IvYeZxxs=;
X-YMail-OSG: 8RtBAI8VM1nsbY8Od7RE3KR7Ub94TE_apjhhIYzCd_N9ZT7__LgPSBw.aUalaJxgInJi1469BcGkbrjhe1jH6iJEz4WW4QQ6_a9TKV.LSj8ggp4mJZYKH7AgXQ--
X-Mailer: YahooMailWebService/0.7.185
Date: Fri, 2 May 2008 07:13:45 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Sharing disks amoung multiple software RAIDs
To: Richard Michael <rmichael-raid@edgeofthenet.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Helge Hafting <helge.hafting@aitel.hist.no>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <481B1A7D.2020000@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <271684.86609.qm@web50210.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Can you explain what you mean, exactly?
> > As an example, you have disks /dev/sd[abc]. /dev/md0 would be made 
> > from /dev/sda1, /dev/sdb1, and /dev/sdc1; /dev/md1 would be made
> > from /dev/sda2, /dev/sdb2, and /dev/sdc2.

> I've been watching this thread with interest, because I wanted
> clarification on what the OP meant.

> If by "sharing disks", the OP meant the above, I'm surprised (and
>  concerned) there's any question at all.  How is this anything other    > than the definition of "mirror"? 
md0 and md1 are both RAID 5 arrays, not mirrors.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
