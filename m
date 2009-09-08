Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbZIHXrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbZIHXrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZIHXrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:47:15 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43821 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZIHXrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:47:14 -0400
Date: Tue, 8 Sep 2009 16:47:17 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Daniel Walker <dwalker@fifo99.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] ceph distributed file system client
In-Reply-To: <1252451427.14793.38.camel@desktop>
Message-ID: <Pine.LNX.4.64.0909081645580.9053@cobra.newdream.net>
References: <1252450601-17610-1-git-send-email-sage@newdream.net>
 <1252451427.14793.38.camel@desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Daniel Walker wrote:

> On Tue, 2009-09-08 at 15:56 -0700, Sage Weil wrote:
> > We would like to see this merged soon.  What is the next step here?
> 
> Several of your patches have checkpatch errors or warnings ..  Usually
> it's good to clean those up prior to merging .. Could you run these
> through checkpatch and take care of any issues that it brings up.

Done; the next set will be clean.

Actually, I also forgot to strip out the #ifdef kernel version 
compatibility cruft before sending too; please ignore those bits.

Thanks-
sage
