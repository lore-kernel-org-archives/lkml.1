Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbZATJjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbZATJjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbZATJis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:38:48 -0500
Received: from web53301.mail.re2.yahoo.com ([206.190.49.91]:34343 "HELO
	web53301.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757490AbZATJiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:38:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=hA+ZZ+6aPPb+qeCQg/ml+HGUwLNtCQ37kIJ7sSft5Mtsb9EjAT42/81CGzMdUem2RKH5az7virSUYeIfx5tRARYRyscMplLpl4n6CbYCu4OL2lUG9L0f9YibsWsjVNO59mRziA7hYu5wkC7qsj753/tv/W34Akr/OYK64SVFtBE=;
X-YMail-OSG: 1elQFvIVM1mBGu2oF_YPvImBjPgjkhiS.aGWwEwOmdBhtGKzYTzm.X9.NUxhGp8YL_.j4bIRKMublMSH.TJ0nxUPsX_2.QXAubw3OlnYNL8vAXkBW11EUF0GYHWSnRYLOCFR5q0MukBi9OqocwnTHBXMt.VIBWASH.w.FsVte6X8RXo7rTt6b0PEOuwUQ_s40hbwyuiZe0fa4ghlUmoMMcjNe1Dv5mk-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Tue, 20 Jan 2009 01:38:45 -0800 (PST)
From: Alberto Gonzalez <luis6674@yahoo.com>
Reply-To: luis6674@yahoo.com
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <cX2gZ6Cy9nC.A.e-C.AKRdJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <405772.76349.qm@web53301.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 1/19/09, Rafael J. Wysocki wrote:

> 
> The following bug entry is on the current list of known
> regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it
> still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	:
> http://bugzilla.kernel.org/show_bug.cgi?id=12337
> Subject		: ~100 extra wakeups reported by powertop
> Submitter	: Alberto Gonzalez <luis6674@yahoo.com>
> Date		: 2008-12-31 12:25 (20 days old)

Yes, the problem is still present in 2.6.28.1

Thanks,
Alberto.


      
