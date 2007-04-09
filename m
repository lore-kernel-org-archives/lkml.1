Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbXDIRt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbXDIRt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbXDIRt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:49:58 -0400
Received: from smtp.osdl.org ([65.172.181.24]:53202 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbXDIRt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:49:57 -0400
Date: Mon, 9 Apr 2007 10:49:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL -mm] Unionfs branch management code
Message-Id: <20070409104948.2bc99202.akpm@linux-foundation.org>
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Apr 2007 10:53:51 -0400 "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu> wrote:

> The following patches introduce new branch-management code into Unionfs as
> well as fix a number of stability issues and resource leaks.

I have a mental note that unionfs is in the "stuck" state, due to general
agreement that we should implement this functionality at the VFS level, one
reason for which is unionfs's upper-vs-lower coherency problems.

Am I wrong?
