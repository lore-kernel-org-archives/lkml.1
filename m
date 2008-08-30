Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbYH3WVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbYH3WVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 18:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYH3WVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 18:21:02 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:46355 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbYH3WVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 18:21:00 -0400
Message-ID: <48B9C7C6.2060209@dgreaves.com>
Date: Sat, 30 Aug 2008 23:20:54 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11460] 2.6.27-rc3 to -rc4 regression: init 0 hangs in halt
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik> <N8SeMoDzuxC.A.-VD.xhbuIB@albercik>
In-Reply-To: <N8SeMoDzuxC.A.-VD.xhbuIB@albercik>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11460
> Subject		: 2.6.27-rc3 to -rc4 regression: init 0 hangs in halt
> Submitter	: David Greaves <david@dgreaves.com>
> Date		: 2008-08-30 04:07 (1 days old)

Yes.

I'm trying to bisect it but came across a bug/problem in git doing bisects.
(see message subject "setlocalversion wasn't producing git labels for bisect")

David

