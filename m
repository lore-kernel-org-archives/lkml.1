Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbXKFJOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbXKFJOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbXKFJOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:14:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753762AbXKFJOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:14:03 -0500
Date: Tue, 6 Nov 2007 01:12:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu, hch@infradead.org, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH 16/27]
 r-o-bind-mounts-elevate-write-count-for-some-ioctls
Message-Id: <20071106011239.40d376ea.akpm@linux-foundation.org>
In-Reply-To: <20071106090102.GA32704@atrey.karlin.mff.cuni.cz>
References: <20071101230826.9A4F6E00@kernel>
	<20071101230847.1CD52DBD@kernel>
	<20071105152346.9060641a.akpm@linux-foundation.org>
	<20071106090102.GA32704@atrey.karlin.mff.cuni.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007 10:01:02 +0100 Jan Kara <jack@suse.cz> wrote:

>   Why there's no modification for reiserfs?

I fixed that in the base patch while repairing some rejects.
