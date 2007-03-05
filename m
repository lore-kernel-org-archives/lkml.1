Return-Path: <linux-kernel-owner+w=401wt.eu-S933583AbXCEQAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583AbXCEQAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbXCEQAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:00:08 -0500
Received: from web52513.mail.yahoo.com ([206.190.48.196]:25126 "HELO
	web52513.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933575AbXCEP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:59:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=pepAd0tzMIftSvU640+wh/YiYMovm6vnlD1xgnJgjAct5Xtd8Edq11+V4NbHssJEZzVAXI4xkZagrOCtekRczGdrYyv/3O5lQioIaUa2feowF/5clpYNwXiP0bkc4NVmvKxRmjji8EpLfqmBvvkDT8ZVL5QBtXXdwHzNyyJa8nI=;
X-YMail-OSG: VwlX6A0VM1k1QpWgDjuOwPrMXxzpivCcPks6PXRmNbcKVcJ9w_vXONDcVFOW1dNu7vQf9RnQL0UD1M9tDkF1sVjWnAoGgnhEkFIztT8DDoiX2Ej.fyT.MSPQXSMqAhEejQ2BT3s54b0DWXqlESSUyyNFnA--
Date: Mon, 5 Mar 2007 07:59:44 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Raid 10 Problems?
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0703051328240.23714@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <708349.8753.qm@web52513.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On Mar 4 2007 19:37, Marc Perkel wrote:
> >> 
> >>   -b internal -- seems like a good idea to speed
> up
> >>   resynchronization.
> >
> >I'm trying to figure out what the default is. 
> 
> -b none, meaning the whole drive will be
> resynchronized when the
> even counters don't match.
> 
>
http://gentoo-wiki.com/HOWTO_Install_on_Software_RAID#Write-intent_bitmap
> 
> 

That information has been extremely useful. Thanks a
lot. I fund a command to do the bitmap internal after
the array was made so I added that. Seems like some of
these features should be default. Maybe it's time for
the raid folks to update what is default?



 
____________________________________________________________________________________
8:00? 8:25? 8:40? Find a flick in no time 
with the Yahoo! Search movie showtime shortcut.
http://tools.search.yahoo.com/shortcuts/#news
