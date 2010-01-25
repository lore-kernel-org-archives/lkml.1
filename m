Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642Ab0AYD0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0AYD0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 22:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279Ab0AYD0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 22:26:43 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:41160 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0AYD0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 22:26:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ax8NgwhQfYAxhYshRpE4y8Cex0IWBZ4l1pVQu8/rOub8S9PwVpW4aGfwcq49dD4nlL
         OHQMTP7AkOcI1M3i9pbCIphtijZ/0bHIDg/Mp12Kkm3nu4zAbIEZpjAiLJ1zTYkkGkOs
         v3AUjn6rYJ/ctBYZXGnww17n37a4rBLie2LpM=
MIME-Version: 1.0
In-Reply-To: <hE3x9c-4KZM.A.kWG.mKMXLB@chimera>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	 <hE3x9c-4KZM.A.kWG.mKMXLB@chimera>
Date: Sun, 24 Jan 2010 22:26:40 -0500
Message-ID: <a728f9f91001241926m4c19aedbvda295fe3c7daade@mail.gmail.com>
Subject: Re: [Bug #15017] kexec regression, radeon/kms irq related (bisected)
From: Alex Deucher <alexdeucher@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 5:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15017
> Subject         : kexec regression, radeon/kms irq related (bisected)
> Submitter       : Markus Trippelsdorf <markus@trippelsdorf.de>
> Date            : 2010-01-09 18:49 (16 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d8f60cfc93452d0554f6a701aa8e3236cbee4636
>
>
>

That bug has patches which fix the issue attached and queued for 2.6.33.

Alex
