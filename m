Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbXDKV0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbXDKV0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 17:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbXDKV0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 17:26:41 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:46832 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXDKV0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 17:26:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17949.21121.978480.650831@smtp.charter.net>
Date: Wed, 11 Apr 2007 17:26:25 -0400
From: "John Stoffel" <john@stoffel.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, "John Stoffel" <john@stoffel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
In-Reply-To: <200704111716.17202.gene.heskett@gmail.com>
References: <200704091007.58535.gene.heskett@gmail.com>
	<200704111529.01412.gene.heskett@gmail.com>
	<17949.17594.183344.591786@smtp.charter.net>
	<200704111716.17202.gene.heskett@gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Gene> Humm, interesting John.  Neither yumex, or smart, is offering it
Gene> to me as an installable rpm for FC6.

Go and grab it from http://www.bacula.org, I'm pretty sure there are
RPMs available on there.  You might also need to install seperate RPMs
for the follwoing packages:

	bacula-common
	bacula-director
	bacula-sd
	bacula-fd
	bacula-console
	bacula-mysql

Oh yeah, bacula really wants to use an SQL DB for it's file index.  So
I'd strongly suggest you go and read the manual,which is quite
complete, before you do anything else.

Feel free to contact me off-list for help, or join the bacula-users
list.  We're a bit off topic for LKML now...

John
