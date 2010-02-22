Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0BVBbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 20:31:37 -0500
Received: from mail-qy0-f184.google.com ([209.85.221.184]:38052 "EHLO
	mail-qy0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab0BVBbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 20:31:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZPO1yrpSemaJBta1LmvLXYDL9rFePLQdJ33qIN7EJ59z9VK13UW69Nfs8DtoQwu2GN
         gkv0LTzilvg4BKcCSKa9H+vAixprJkvRJZRbBGd+vJ8OTTLBMMVpgUr9hI/5bspQYwng
         eVvfus/ZmxWGFH4OzWvs5QZGAhonixPRMFPn4=
MIME-Version: 1.0
In-Reply-To: <ClJsQB_ZlxO.A.S_E.RcagLB@chimera>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
	 <ClJsQB_ZlxO.A.S_E.RcagLB@chimera>
Date: Mon, 22 Feb 2010 09:31:34 +0800
Message-ID: <2375c9f91002211731y354a7975oc863db321375d330@mail.gmail.com>
Subject: Re: [Bug #15319] [BUG]: Possibe recursive locking detected in sysfs
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Eric Biederman <ebiederm@aristanetworks.com>,
       John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 5:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15319
> Subject         : [BUG]: Possibe recursive locking detected in sysfs
> Submitter       : John Kacur <jkacur@redhat.com>
> Date            : 2010-02-11 17:11 (11 days old)
> Message-ID      : <520f0cf11002110911t3f125649v73062e9851e2cfb3@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=126590832432598&w=2
> Handled-By      : Eric Biederman <ebiederm@aristanetworks.com>
>
>

http://lkml.org/lkml/2010/2/11/329
