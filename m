Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbZCCW3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbZCCW3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZCCW3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:29:19 -0500
Received: from web53307.mail.re2.yahoo.com ([206.190.49.97]:43672 "HELO
	web53307.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754878AbZCCW3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:29:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=gfSKGPY0g613qGciiVptYw1LGxtkd1JiC8M+4fogxLaDkiBNeb4/pSlxlpm3MEOq0MfbpV0XL5K9YhO0AD7zo2u0bqtPxtmvvdmw4hLFoBBD0qPFutG3EPw9IaNwJ8W8KDPcbDtLcGiaggsuRLYxPRih8a7HH3JuwR5Mdaz5jdY=;
X-YMail-OSG: xqym.r8VM1locyEPHgI6DYjTzNXrEgBWhSR34EKFFh7mUzJBU4glqbxLSDNujQXvMvu0DX5GD5rO5BUjegj0R0fUff58LS5bVXmLhRZgvrKMbmqClRH2WP8oCHcjorx_CcWibzcqHw7I5zgqwlFDinHJdRoZ86UHZj7hsfsjfmGTBBsYysPtczBVC_TCmG6u4iFM9eRVHMXkNMVs
X-Mailer: YahooMailWebService/0.7.289.1
Date: Tue, 3 Mar 2009 14:29:15 -0800 (PST)
From: Alberto Gonzalez <luis6674@yahoo.com>
Reply-To: luis6674@yahoo.com
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <pRIaSZpQ1ON.A.vgD.OearJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <814185.48201.qm@web53307.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 3/3/09, Rafael J. Wysocki wrote:

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
> Date		: 2008-12-31 12:25 (63 days old)

J. Barnes said this is a bug in the intel driver, even if it appeared after a kernel upgrade.

If you prefer to close it for now, fine with me. If you prefer to wait until it's confirmed, fine too. Whatever is ore convenient for your tracking.

I'll update the report in any case when I know more.

Regards,
Alberto.


      
