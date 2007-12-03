Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbXLCXqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbXLCXqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXLCXqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:46:12 -0500
Received: from mail.transmode.se ([83.241.175.147]:31073 "EHLO
	tmnt04.transmode.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbXLCXqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:46:11 -0500
From: "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
To: "'Mark Fasheh'" <mark.fasheh@oracle.com>
Cc: <linux-kernel@vger.kernel.org>
References: <056a01c835e9$5b7203f0$5267a8c0@Jocke> <20071203213406.GJ28607@ca-server1.us.oracle.com>
Subject: RE: what happened to RELATIME?
Date: Tue, 4 Dec 2007 00:46:04 +0100
Message-ID: <057e01c83606$aadc09f0$5267a8c0@Jocke>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: <20071203213406.GJ28607@ca-server1.us.oracle.com>
thread-index: Acg19HRT9z25kxgCTIOYA69wGjgc4QAEbV1g
X-OriginalArrivalTime: 03 Dec 2007 23:46:07.0894 (UTC) FILETIME=[ACEC7360:01C83606]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Fasheh [mailto:mark.fasheh@oracle.com] 
> Sent: den 3 december 2007 22:34
> To: Joakim Tjernlund
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: what happened to RELATIME?
> 
> On Mon, Dec 03, 2007 at 09:16:15PM +0100, Joakim Tjernlund wrote:
> > Looking in 2.6.23 sources it seems like only ocfs2 has added
> > support for RELATIME. Was RELATIME a bad idea or is there
> > some other reason other filesystems hasn't added support?
> 
> Ocfs2 just needs a bit of explicit support - as far as I 
> recall, other file
> systems should have gotten it automagically via the generic 
> vfs changes.
> 	--Mark

Ahh, that explains it. Can anyone confirm that all in
FS:es honours relatime?

Thanks, Jocke

