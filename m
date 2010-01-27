Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066Ab0A0Mo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0A0Mo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917Ab0A0Mo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:44:28 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:55954 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab0A0Mo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:44:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mN7grKPboayIvhf3ONm1GaySxmSpogjTYYAlhOnU1dmZzgtA2F9KF9vQfURkZw7F6n
         c5K46DyT91OMANN7pGjhmvDuL/AztiF6SIaAzLiXgC0pdtpED4eGtxOLK5mxA09giiD8
         6dAByzRnnd7/zuDnmHiDr4NBTtUx56RhNUBTc=
MIME-Version: 1.0
In-Reply-To: <q60Z28d_9yH.A.7k.sZMXLB@chimera>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	 <q60Z28d_9yH.A.7k.sZMXLB@chimera>
Date: Wed, 27 Jan 2010 14:44:25 +0200
X-Google-Sender-Auth: da36f45544d80e48
Message-ID: <84144f021001270444o1a2eba51t7917fb447cdc247d@mail.gmail.com>
Subject: Re: [Bug #14897] i915: Commit 0e442c60 causes flickering
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David John <davidjon@xenontk.org>, Eric Anholt <eric@anholt.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 12:23 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14897
> Subject         : i915: Commit 0e442c60 causes flickering
> Submitter       : David John <davidjon@xenontk.org>
> Date            : 2009-12-09 17:26 (47 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e442c60dd39ac6924b11a20497734bd2303744c
> References      : http://marc.info/?l=linux-kernel&m=126037889600769&w=4

David, bunch of i915 flickering fixes have gone into 2.6.33-rc5. Is
this still a problem?
