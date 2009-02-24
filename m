Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbZBXKx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbZBXKx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 05:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZBXKxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 05:53:48 -0500
Received: from web53304.mail.re2.yahoo.com ([206.190.49.94]:33004 "HELO
	web53304.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751743AbZBXKxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 05:53:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=bdAzPlFCiD6i1eopxn04MDP28hASxWex9OwdikK2FX/B2vL0oLUg9U8Z27frwRmDLJ/crsR8+feJucx8MV+O+MALaZDH6ZNPbX0Qq+StHAlvVMRG4CYoYpHgypFJiT/a0fDir5G2J49U2QEcia1L8IUgF3KSisTy4NCBXqMW/tc=;
X-YMail-OSG: 0T1UziIVM1kp9mGvkv3CXjktUqplStj2dh5nggBdDuutj9m06DXKk9qFa4Bf_arSPK.wQ4D.oO1T.b4ezEy8nbwfLeMl6mwUQgeDMqwNjHyP3JnZy1C8V6ndsRv2KfGSOKfp95ZJoC_sknmW0T9YFXrnCP06PNikA43zsRe4jnv2UiyFdEJ7CV_NHrVCTY1MCq0AIjvU53Fx
X-Mailer: YahooMailWebService/0.7.260.1
Date: Tue, 24 Feb 2009 02:53:44 -0800 (PST)
From: Alberto Gonzalez <luis6674@yahoo.com>
Reply-To: luis6674@yahoo.com
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <LLno3yT_fnC.A.Un.8zzoJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <37338.58465.qm@web53304.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 2/23/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:

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
> Date		: 2008-12-31 12:25 (55 days old)

Still present, yes.


      
