Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZKQMf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZKQMf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZKQMfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:35:55 -0500
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:53577 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbZKQMfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:35:55 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2009 07:35:54 EST
Date: Tue, 17 Nov 2009 13:27:26 +0100
From: Lukas Kolbe <lkolbe@TechFak.Uni-Bielefeld.DE>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14577] Data Corruption with Adaptec 52445, Firmware
	5.2-0 (17380)
Message-ID: <20091117122726.GH26279@TechFak.Uni-Bielefeld.DE>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.3eG.ETdALB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xXQGFmujPl.A.3eG.ETdALB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

>This message has been generated automatically as a part of a report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.31.  Please verify if it still should be listed and let me know
>(either way).

It is still valid. We haven't yet been able to verify if it is either a
hardware problem (working with the adaptec folks to sort that out) or a
kernel problem (working with you to find that out ;). Kernel 2.6.30, as
already said, seems to think everything is fine, so it really might be a
regression.

>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14577
>Subject		: Data Corruption with Adaptec 52445, Firmware 5.2-0 (17380)
>Submitter	:  <lkolbe@techfak.uni-bielefeld.de>
>Date		: 2009-11-10 13:31 (7 days old)

-- 
Lukas Kolbe

