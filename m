Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZCGFxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZCGFxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 00:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZCGFxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 00:53:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:25552 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZCGFxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 00:53:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Qjw26KZu3eY/OM+i8FV7I6zt0HS7hObXfDwvETLzWK5neRQZQOdHFuxOP9v//RYINA
         mC6duJDRr5KuGQq+8pTWq0vH2zaOP/fj7F9p+DMmcyQ+b7e0oyu+H4I710Czj90/gUxQ
         m7zSZ/9bESgYGPojR9z05rPqCDEmHSqf5qB6Y=
Subject: Re: [Bug #12806] i915 broken STR
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, Eric Anholt <eric@anholt.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <SLCXkuHtxAO.A.QeB.sUarJB@chimera>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
	 <SLCXkuHtxAO.A.QeB.sUarJB@chimera>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 21:53:07 -0800
Message-Id: <1236405187.7409.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 20:25 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12806
> Subject		: i915 broken STR
> Submitter	: Harvey Harrison <harvey.harrison@gmail.com>
> Date		: 2009-02-28 4:20 (4 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5669fcacc58bf3a7386057addffd280d75380858
> References	: http://marc.info/?l=linux-kernel&m=123579487801064&w=4
> 
> 

This looks to have been a case of old-userspace..upgrading to
xorg-intel-video 2.6.1 (ubuntu Jaunty Alpha5) fixes STR here.

Harvey



