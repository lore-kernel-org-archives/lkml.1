Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZD0GrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZD0GrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 02:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbZD0GrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 02:47:03 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4052 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbZD0GrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 02:47:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13003] [2.6.29 regression] ivtv driver causes strange oops'es, disrupts software suspend
Date: Mon, 27 Apr 2009 08:46:28 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Artem S. Tashkinov" <t.artem@mailcity.com>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <egHshlwQQFE.A.C_C.ipE9JB@chimera>
In-Reply-To: <egHshlwQQFE.A.C_C.ipE9JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904270846.28726.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 April 2009 11:46:28 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13003
> Subject		: [2.6.29 regression] ivtv driver causes strange oops'es,
> disrupts software suspend Submitter	: Artem S. Tashkinov
> <t.artem@mailcity.com>
> Date		: 2009-04-03 14:57 (24 days old)
> Handled-By	: Hans Verkuil <hverkuil@xs4all.nl>

This isn't a 2.6.29 regression. It is a bug - somewhere - but it's also been 
reproduced under 2.6.28 so it doesn't qualify as a regression.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
