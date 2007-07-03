Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbXGCQrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbXGCQrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760011AbXGCQp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:45:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:63278 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbXGCQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=mzQqLXS7l0CF3xnXop2NfdBFrS2AU5cxspcnWT8XsEcU/ytDlj6Hz3DCuEeEmuFAIlZYneKhal73pIphZDfzKoqEnsmu+V9SV3UfwPQhqoUl1yjAOULGQINGq5EURSRx58fILiarlx+JVhrgElKp02d2VjKv/as4K61Mjq6tljY=
Message-ID: <468A7D1C.4060701@googlemail.com>
Date: Tue, 03 Jul 2007 18:45:16 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       Ioan Ionita <opslynx@gmail.com>
Subject: Re: [2/2] 2.6.22-rc7: known regressions
References: <468A7BF3.1090001@googlemail.com>
In-Reply-To: <468A7BF3.1090001@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc7.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Hugh Dickins                           2
Andi Kleen                             1
Andrew Morton                          1
Benjamin Herrenschmidt                 1
Björn Steinbrink                       1
Bjorn Helgaas                          1
Jean Delvare                           1
Olaf Hering                            1
Siddha, Suresh B                       1
Trent Piepho                           1
Ville Syrjälä                          1



Suspend

Subject         : reiserfs/libata sporadically hangs on resume from hibernation
References      : http://lkml.org/lkml/2007/6/30/5
Last known good : ?
Submitter       : Andrey Borzenkov <arvidjaar@mail.ru>
Caused-By       : ?
Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
Status          : problem is being debugged



x86-64

Subject    : x86-64 2.6.22-rc2 random segfaults
References : http://lkml.org/lkml/2007/5/24/275
Submitter  : Ioan Ionita <opslynx@gmail.com>
Status     : Unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
