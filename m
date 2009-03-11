Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZCKNKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZCKNKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZCKNJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:09:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:55244 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbZCKNJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:09:57 -0400
Message-ID: <49B7B7E7.8020501@windriver.com>
Date: Wed, 11 Mar 2009 08:08:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: frank.rowand@am.sony.com
CC: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] kgdb: documentation
References: <49B5CA78.3080300@am.sony.com>
In-Reply-To: <49B5CA78.3080300@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2009 13:08:54.0444 (UTC) FILETIME=[87AEF6C0:01C9A24A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frank Rowand wrote:
> gdb command "set remote debug 1" is not valid, change to correct command.
>
> Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
>
>   

Thanks Frank,

I merged this change.

Cheers,
Jason.
