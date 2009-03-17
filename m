Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbZCQEGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbZCQEGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 00:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZCQEFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 00:05:52 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:49363 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZCQEFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 00:05:51 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC Aufs2 #2 21/28] aufs sysfs entries 
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090317033747.GA17037@kroah.com>
References: <1237188040-11404-1-git-send-email-hooanon05@yahoo.co.jp> <1237188040-11404-22-git-send-email-hooanon05@yahoo.co.jp> <20090316180538.GA7069@kroah.com> <7200.1237260402@jrobl> <20090317033747.GA17037@kroah.com>
Date: Tue, 17 Mar 2009 13:05:47 +0900
Message-ID: <7974.1237262747@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg KH:
> Which should be MAX_PATH, right?  Is that ever bigger than PAGE_SIZE?

Is the limit of PATH_MAX applied to the absolute path too?


> What specifically are you trying to show here?

- the abs path of a directory which is a member of a union.
- the abs path of a xino file which is a regular file maintained by
  aufs.


> Please document your sysfs entries, and I'll be glad to review it again.

Thank you.
I will create Documentation/ABI/testing/sysfs-aufs and describe them in
it. I didn't know about it.


J. R. Okajima
