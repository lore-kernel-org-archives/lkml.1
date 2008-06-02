Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYFBJl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYFBJl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYFBJlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:41:18 -0400
Received: from saeurebad.de ([85.214.36.134]:54473 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYFBJlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:41:18 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bug #10741] bug in `tty: BKL pushdown'?
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	<UJSav77TyUB.A.llE.zrZQIB@albercik> <878wxotfto.fsf@saeurebad.de>
	<200806021037.35384.rjw@sisk.pl>
Date: Mon, 02 Jun 2008 11:40:41 +0200
In-Reply-To: <200806021037.35384.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Mon, 2 Jun 2008 10:37:34 +0200")
Message-ID: <87zlq4rx7q.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Monday, 2 of June 2008, Johannes Weiner wrote:
>> Hi,
>
> Hi,
>  
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.25.  Please verify if it still should be listed.
>> >
>> >
>> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
>> > Subject		: bug in `tty: BKL pushdown'?
>> > Submitter	: Johannes Weiner <hannes@saeurebad.de>
>> > Date		: 2008-05-18 2:16 (14 days old)
>> > References	: http://marc.info/?l=linux-kernel&amp;m=121107706506181&amp;w=4
>> > Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
>> 
>> Bug still exists in Linus' current tree.
>
> Thanks for the update.
>
> Alan says it's a user space bug, though.

Alan could you hint me what to look for in screen?   What in the commit
I bisected could cause breakage for it?

Thanks,
	Hannes
