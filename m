Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbXFIRlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbXFIRlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 13:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757158AbXFIRku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 13:40:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:5598 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892AbXFIRkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 13:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=TTjdw0mKE0sep1mKU2v8eeYF7VFqQFJx8VX2ViXbp+yjlcDGHAssnHO8h0f9/LjAZ+8CGRGPWeSevvLXy4kNozlbFiQG+RHRmzpk4DRkVPeF8vO+7rJtnejzl8xNcE2TkyKGSPamVhHYgkFo6I4ToBxyUkJrhL/23hP3K1nz1ZA=
Message-ID: <466AE60D.8030606@googlemail.com>
Date: Sat, 09 Jun 2007 19:40:29 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Alex Riesen <raa.lkml@gmail.com>, Andi Kleen <ak@suse.de>,
       discuss@x86-64.org, Ioan Ionita <opslynx@gmail.com>
Subject: Re: [3/3] 2.6.22-rc4: known regressions v2
References: <466ADBE4.5090707@googlemail.com>
In-Reply-To: <466ADBE4.5090707@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Suspend

Subject    : hibernate(?) fails totally - regression
References : http://lkml.org/lkml/2007/6/1/401
Submitter  : David Greaves <david@dgreaves.com>
Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
Caused-By  : Tejun Heo <htejun@gmail.com>
             commit 9666f4009c22f6520ac3fb8a19c9e32ab973e828
Status     : problem is being debugged



TTY

Subject    : OOPS (NULL pointer dereference) in v2.6.22-rc3
References : http://lkml.org/lkml/2007/6/1/389
             http://bugzilla.kernel.org/show_bug.cgi?id=8473
             http://bugzilla.kernel.org/show_bug.cgi?id=8574
Submitter  : Alex Riesen <raa.lkml@gmail.com>
Status     : problem is being debugged



x86-64

Subject    : x86-64 2.6.22-rc2 random segfaults
References : http://lkml.org/lkml/2007/5/24/275
Submitter  : Ioan Ionita <opslynx@gmail.com>
Status     : Unknown



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"
