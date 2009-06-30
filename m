Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZF3SiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZF3SiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 14:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZF3SiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 14:38:01 -0400
Received: from ey-out-1920.google.com ([74.125.78.147]:5850 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZF3SiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 14:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=iLZL36LdSy9GuczNKb3L0rvGbtAKVzkQwns8bcbwtU/jZglPXyvqORwus8CD/OuoXd
         x66i/m+gUGfrr/pNo282tNE5FqLGMLQHQkczrzem5dwRDddV25ScspTale0QBFuHeZhe
         W5XOqh9ujcmPJ63i/sSATCauBntYY3SFX2qKY=
Date: Tue, 30 Jun 2009 20:37:54 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #13362] rt2x00: slow wifi with correct basic rate bitmap
Message-ID: <20090630203754.3b7bec39@varda>
In-Reply-To: <5Hhc7UkUKEO.A.E1G.bkASKB@chimera>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	<5Hhc7UkUKEO.A.E1G.bkASKB@chimera>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 29 Jun 2009 02:30:55 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> escribió:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).

 There is no 2.6.30.1 to see if it has been fixed and i have not tested
2.6.31-rc1 (too early for me) so i think it should be still listed

> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13362
> Subject		: rt2x00: slow wifi with correct basic rate bitmap
> Submitter	: Alejandro Riveira <ariveira@gmail.com>
> Date		: 2009-05-22 13:32 (38 days old)
> 
> 
