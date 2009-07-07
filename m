Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZGGKHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZGGKHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 06:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZGGKGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 06:06:54 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:35782 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbZGGKGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 06:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=RhrgnB1HZyka+FfyIThMN/28EEFWwFAGqQEvmkyvO1NhvTqnpwCXfuLxPc12rZeybh
         fHztNyplb2TqHyzTTWdDjW1yT+arsf9WUZr8QEyT+g8QuHlpHVjLspNRgemZhHMN/IrM
         KoQj4lnixyI250PRINW3UaDJr28Se7a1a6n1M=
Date: Tue, 7 Jul 2009 12:06:51 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #13362] rt2x00: slow wifi with correct basic rate bitmap
Message-ID: <20090707120651.063e1b1a@varda>
In-Reply-To: <bXZeuxPQAWE.A.Nd.YBpUKB@chimera>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	<bXZeuxPQAWE.A.Nd.YBpUKB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue,  7 Jul 2009 02:00:38 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> escribió:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 

 It should be still listed 2.6.30.1 does not fix it. still not tried
2.6.31-rc* though.

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13362
> Subject		: rt2x00: slow wifi with correct basic rate bitmap
> Submitter	: Alejandro Riveira <ariveira@gmail.com>
> Date		: 2009-05-22 13:32 (46 days old)
> 
> 
