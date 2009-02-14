Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZBNXfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZBNXfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbZBNXf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:35:28 -0500
Received: from web53303.mail.re2.yahoo.com ([206.190.49.93]:35025 "HELO
	web53303.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752510AbZBNXf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:35:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=XSvxic5mh0QNqU+KaNRZW6XFYhXDdXYKC8slaDewKetuQAxU3Gc9Echk2YHEYlnG6vXuRKuZAgm/RqdwHfvZGEqA8FSv3CdZustqxNFOj9nQjZKcI96GCMYuIVkoi2iGc//C3ih+/Hn/un0jTyRXyPZw8fhsQ9MMT7LRUlI2Tu8=;
X-YMail-OSG: lytyOgUVM1mKtn0.cCc9KHub1_Yfadz2ilJjJzmjHuCl1cxll20GmNyvIsuJGm.5nSiNPJqbLBXSFMYMYDVb2gn9R4mxcGE9NNsPFQGya5TitLsVbLSEt_ftWmUAn01ficJrRwbBtkMAN01X6qsBWE6.46NRLRjFuYxUxoOvv2E4_RwqmeZWoYx9N.PdH2wNnZQaID6AOU7I
X-Mailer: YahooMailWebService/0.7.260.1
Date: Sat, 14 Feb 2009 15:35:23 -0800 (PST)
From: Alberto Gonzalez <luis6674@yahoo.com>
Reply-To: luis6674@yahoo.com
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <ROx6X68CGJG.A.NVB.U50lJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <535841.27007.qm@web53303.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sat, 2/14/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:

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
> Date		: 2008-12-31 12:25 (46 days old)

Yes, still present in latest stable 2.6.28.5

I updated the report to say that this happened on my 5 year old Pentium 4, but now I got a new Dell desktop (Intel G45 based) and the exact same problem happens, so I can't be the only one seeing it. In the bugzilla Eric Anholt said that it could be related to vblank and that jbarnes had look into a similar issue before, so maybe he has some clue.

Thanks.


      
