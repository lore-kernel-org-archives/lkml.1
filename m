Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXCDXKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXCDXKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 18:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXCDXKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 18:10:25 -0500
Received: from web52503.mail.yahoo.com ([206.190.48.186]:25785 "HELO
	web52503.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752000AbXCDXKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 18:10:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=pljS3o5ZhS2HymyuuyIJ+cH4rDr1hCFFWQ7d21FDXCDp5DITRikRLI86Q062nkxyfhXRTPpnKuOYWD7ZzesCUcuUIq4b5Cnu5CFW5VznJgAHmBIGTxCp+Zp5ansRyASpgM6GBM9vSHko6bFHyeoHcu7snX7EydrXJjOb0Q06Zzw=;
X-YMail-OSG: V_OhDwkVM1nZQuGQXdcwzRKtnE6EjuBkoph1bwBvodmYL5iMi55aQMTUPT8VLbvmVICAOcTAhPioKdREAGHhX3nd7NambXpYAkQCxbSd.nzOvRBZDtxBGIbPQLf7pWKZ3S6JODPFg42vug--
Date: Sun, 4 Mar 2007 15:10:23 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Raid 10 Problems?
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0703041832180.23714@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <362890.42714.qm@web52503.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On Mar 4 2007 08:25, Marc Perkel wrote:
> >I'm running the latest OpenVZ kernel 2.6.18. I'm
> not
> >sure if this is a factor or not as the problem
> occurs
> >without starting any VEs.
> >
> >I've never used raid 10 before (stripes on top of 2
> >mirrors) so I don't have anything to compare this
> >with. I'm just wondering if I'm doing something
> wrong.
> 
> Are you using raid1+0 (3 md devices) or raid10 (1
> raid device)?
> Depending on which, you might want to try the other.
> 
> 
> Jan
> -- 


I'm using 3 devices. Can you use just one? If so -
how?
How do I create a raid 10 using mdadm?



 
____________________________________________________________________________________
Want to start your own business?
Learn how on Yahoo! Small Business.
http://smallbusiness.yahoo.com/r-index
