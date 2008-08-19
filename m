Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbYHSVc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbYHSVc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758859AbYHSVcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:32:11 -0400
Received: from gw.goop.org ([64.81.55.164]:55979 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758701AbYHSVcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:32:09 -0400
Message-ID: <48AB3BAA.9090009@goop.org>
Date: Tue, 19 Aug 2008 14:31:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11313] Plugging HDMI causes "unable to handle kernel paging
 request"
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>	 <sNRO-BDDjQL.A.DYF.sazpIB@albercik> <b170af450808171228i37951c6vd77071da7584669b@mail.gmail.com>
In-Reply-To: <b170af450808171228i37951c6vd77071da7584669b@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki wrote:
> 2008/8/16, Rafael J. Wysocki <rjw@sisk.pl>:
>   
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.26.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11313
>> Subject		: Plugging HDMI causes "unable to handle kernel paging request"
>> Submitter	: Rafał Miłecki <zajec5@gmail.com>
>> Date		: 2008-08-12 14:30 (5 days old)
>>     
>
> Bug still exists in current git (tested 15 minutes ago).
>   

What's your .config on this kernel, BTW?

    J
