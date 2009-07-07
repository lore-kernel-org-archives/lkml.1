Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbZGGHcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbZGGHcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZGGHcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:32:08 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:60078 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZGGHcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:32:07 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13682] The webcam stopped working when upgrading from 2.6.29 to 2.6.30
Date: Tue, 7 Jul 2009 09:32:21 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Nathanael Schaeffer" <nathanael.schaeffer@gmail.com>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.b0F.x_oUKB@chimera>
In-Reply-To: <bXZeuxPQAWE.A.b0F.x_oUKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907070932.22211.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 7. Juli 2009 02:01:07 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13682
> Subject		: The webcam stopped working when upgrading from 2.6.29 to 2.6.30
> Submitter	: Nathanael Schaeffer <nathanael.schaeffer@gmail.com>
> Date		: 2009-06-30 13:34 (7 days old)

This is caused by selecting a format (no longer / not) supported. Please make
an strace of the failing programm so we know what it requests.

	Regards
		Oliver

