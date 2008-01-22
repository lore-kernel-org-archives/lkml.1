Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbYAVQMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbYAVQMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYAVQML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:12:11 -0500
Received: from web36713.mail.mud.yahoo.com ([209.191.85.47]:38764 "HELO
	web36713.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751101AbYAVQMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:12:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=hx4AUJYF6IYdqd6XLO5Kk2t/HiElpbkkA9Xotq65F6MZWAG2Blo5SJT4xZmg0+Yat3OFPL/xzQM32/W6OHLWzpkbQL8bCcKbcH+wePW3fTbBe9qfUH8j5MiiKpVWGo/l/RWa3HNsZkdLH3SMYZhaR3JdcoZJ3wCd1c8APdja8g8=;
X-YMail-OSG: AWnbzocVM1kryhs0jIbCXhDH1QiieQOJNJmfOY.vEyDr6DJH7U34xrH8ZTwK0PgaHkspgqZvwNJVAys3MFmwu6HJ.Fbyz0LbUyR2ATsXTzjoV62biXD1QckYoV6R2mArzhsfDTg4olOHdW_Bkn3aGDBRmfDLSpM-
Date: Tue, 22 Jan 2008 08:12:08 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080110010049.695da076.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <80873.59233.qm@web36713.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed,  2 Jan 2008 17:42:24 +1100 oakad@exemail.com.au wrote:
> 
> > From: Alex Dubov <oakad@yahoo.com>
> > 
> > Sony MemoryStick cards are used in many products manufactured by Sony. They
> > are available both as storage and as IO expansion cards. Currently, only
> > MemoryStick Pro storage cards are supported via TI FlashMedia MemoryStick
> > interface.
> > 
> 
> Will you be running a git tree for this?  If so, please send me the link.
> 

I rectified several additional issues with the driver. I hope you can pull the changes from here:

http://58.96.64.63/~oakad/git/.git memstick




      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

