Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbZEEUNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbZEEUNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 16:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZEEUNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 16:13:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37220 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbZEEUNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 16:13:07 -0400
Date: Tue, 5 May 2009 21:13:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: ReiserFS Devel <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] reiserfs xattr fixups
Message-ID: <20090505201305.GM8633@ZenIV.linux.org.uk>
References: <20090505193014.926371851@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505193014.926371851@suse.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 03:30:14PM -0400, Jeff Mahoney wrote:
>  This series consists of three patches:
> 
>  1) rework the bit of locking after Al's privroot lookup patch
>  2) Fix up security xattrs so they don't apply to other xattrs
>  3) Clean up the privroot hiding since we now cache the privroot early

Applied and pushed to for-next
