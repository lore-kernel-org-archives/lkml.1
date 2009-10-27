Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZJ0Odq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZJ0Odq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZJ0Odp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:33:45 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56904 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZJ0Odo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:33:44 -0400
MIME-Version: 1.0
In-Reply-To: <vX3ILojF2dJ.A.1J.5ff5KB@chimera>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
	 <vX3ILojF2dJ.A.1J.5ff5KB@chimera>
Date: Tue, 27 Oct 2009 10:33:48 -0400
Message-ID: <7e0fb38c0910270733g7b05c779m1f593529659a6ff@mail.gmail.com>
Subject: Re: [Bug #14090] WARNING: at fs/notify/inotify/inotify_user.c:394
From: Eric Paris <eparis@parisplace.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Joerg Platte <bugzilla@jako.ping.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 3:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14090
> Subject         : WARNING: at fs/notify/inotify/inotify_user.c:394
> Submitter       : Joerg Platte <bugzilla@jako.ping.de>
> Date            : 2009-08-30 15:21 (58 days old)

should be fixed by: 9f0d793b52eb2266359661369ef6303838904855 in linus' tree
