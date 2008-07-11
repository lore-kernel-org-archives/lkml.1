Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbYGKWyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbYGKWyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 18:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYGKWyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 18:54:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbYGKWyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 18:54:32 -0400
Date: Fri, 11 Jul 2008 15:52:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Louis Rilling <louis.rilling@kerlabs.com>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, linux-next@vger.kernel.org
Subject: Re: [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup after mkdir()
 failure
Message-Id: <20080711155238.f3e257b0.akpm@linux-foundation.org>
In-Reply-To: <20080711220740.GC22577@mail.oracle.com>
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
	<20080711220740.GC22577@mail.oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 15:07:40 -0700 Joel Becker <Joel.Becker@oracle.com> wrote:

> 	Ok, I've merged all this work.  Please check out my configfs-ALL
> branch and make sure I have everything we've worked on.
> 
> http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=configfs-ALL
> git://oss.oracle.com/git/jlbec/linux-2.6.git configfs-ALL

Can you please arrange to get this tree into linux-next?

Thanks.
