Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209Ab0AMDEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0AMDEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 22:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131Ab0AMDEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 22:04:08 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:10261 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0AMDEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 22:04:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LU2pzHEwqcwnyUTxLDqJW7h4BSShZWmEFjZXU3mpQ8ONvnKUTUSAO1yD87TaVBYtI8
         gn32is4ZbauFA4hOIl8F4uVM20zvXUHjSzcRZ2539Kb3JPfGgAamlxk9MoFQnD04zxcp
         JMJO/UzbHMD4nLE3xldTfiMkjDcX3faHrC/Wk=
MIME-Version: 1.0
In-Reply-To: <omZ8aBZReyD.A.tvF.tMlSLB@chimera>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
	 <omZ8aBZReyD.A.tvF.tMlSLB@chimera>
Date: Wed, 13 Jan 2010 11:04:05 +0800
Message-ID: <2375c9f91001121904h2857760akbf2dd2c9f7441fc5@mail.gmail.com>
Subject: Re: [Bug #15041] Pagemap endless read loop with LTP
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 6:32 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15041
> Subject         : Pagemap endless read loop with LTP
> Submitter       : Andi Kleen <andi@firstfloor.org>
> Date            : 2010-01-10 2:09 (1 days old)
> References      : http://marc.info/?l=linux-kernel&m=126308941423848&w=4
>

According to Andi's later reply, it shoud not be an endless loop,
it just takes a rather long time.

Thanks.
