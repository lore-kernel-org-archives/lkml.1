Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbZH1QaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbZH1QaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZH1QaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:30:21 -0400
Received: from mail-yw0-f184.google.com ([209.85.211.184]:59117 "EHLO
	mail-yw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZH1QaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DAhNCoejN7gaciGDIqlaP4Kar/KirS64c0PdA/QBNgFAYfdVIcPgLO97uGUxnYLyqP
         Q5gdZS2/kwm5T8KABqoq2ZeQHrEoszxJPSW1lHV/GdIqrpC/L1coEr88u7+rnfC4jtdW
         ltq1vGBtYtgKNGsOtzE4Y9tDQ065GtXKFTlIU=
MIME-Version: 1.0
In-Reply-To: <1251476422.28787.1.camel@dhcp231-106.rdu.redhat.com>
References: <Pine.LNX.4.64.0908282358560.19623@boston.corp.fedex.com>
	 <1251476422.28787.1.camel@dhcp231-106.rdu.redhat.com>
Date: Sat, 29 Aug 2009 00:30:22 +0800
Message-ID: <b6a2187b0908280930s6366eda6pe1d5024b4ef890dd@mail.gmail.com>
Subject: Re: Linux-2.6.31-rc8 inotify hangs samba clients
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 12:20 AM, Eric Paris<eparis@redhat.com> wrote:

> Deffinitly not Samba's fault.  I should have 2 patches to fix inotify
> at:
>
> http://git.infradead.org/users/eparis/notify.git/shortlog/refs/heads/for-linus

Eric, didn't expect instantaneous response as I was sending out the
wrong patch and had to correct it.

Thanks again for the pointer and fixes. Will wait to pull from Linus's git.

Jeff.
