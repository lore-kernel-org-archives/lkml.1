Return-Path: <linux-kernel-owner+w=401wt.eu-S1760489AbZBXVkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760489AbZBXVkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760582AbZBXVkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:40:23 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1258 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758914AbZBXVkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:40:22 -0500
Date: Tue, 24 Feb 2009 13:38:48 -0800 (PST)
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: List of 404 URLs in kernel .c and .h files
In-Reply-To: <49A46562.7050906@oracle.com>
Message-ID: <Pine.LNX.4.30.0902241334220.8445-100000@perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Randy Dunlap wrote:
> Joe Perches wrote:
> > Any suggestions on what if anything should be done
> > to the sources with these dead links?
> Did the script truncate the URL?  I see:
> ./drivers/ide/hpt366.c:15: * available from http://www.highpoint-tech.com/BIOS%20+%20Driver/.

Yes, a few times.  The regex was not broad enough.
I'll submit some patches later given your input, thanks.

