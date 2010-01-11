Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849Ab0AKQBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0AKQBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 11:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541Ab0AKQA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 11:00:59 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:59876 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0AKQA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 11:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=v3h+7Fn04Ebbt0KCpfIxHwt76Y+MoGPtykqjBS3unH5rHE6dSG9rQTIjt6nja5SA/5
         fhZFLrX04+u6Ank3PAUIpb+uy8ggctE5Dz0s9IL8XyYsI2uYGzfFkJw81Bm0rpvt2F+e
         zs9kRiiOjBpMDTpWHRw7wiAfJ8kKvpsw57FbY=
MIME-Version: 1.0
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 11 Jan 2010 08:00:37 -0800
Message-ID: <43e72e891001110800h283b534aj1d60f83266fa215a@mail.gmail.com>
Subject: Re: 2.6.33-rc3-git3: Reported regressions from 2.6.32
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 2:27 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message contains a list of some regressions from 2.6.32, for which there
> are no fixes in the mainline I know of.  If any of them have been fixed already,
> please let me know.
>
> If you know of any other unresolved regressions from 2.6.32, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.
>
> Each entry from the list will be sent additionally in an automatic reply to
> this message with CCs to the people involved in reporting and handling the
> issue.
>

Of these only the one below was wireless, which is actually fixed now.
Not bad, rc3 and no wireless regressions yet.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14874
> Subject         : Ath5k regression with commit 8bf3d79bc401ca417ccf9fc076d3295d1a71dbf5
> Submitter       : Joshua Covington <joshuacov@googlemail.com>
> Date            : 2009-12-25 00:49 (17 days old)
> Handled-By      : Luis R. Rodriguez <mcgrof@gmail.com>
> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=24335

  Luis
