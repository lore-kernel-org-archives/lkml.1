Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbZFXEjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbZFXEjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 00:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZFXEjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 00:39:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52785 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZFXEjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 00:39:24 -0400
Date: Wed, 24 Jun 2009 05:39:26 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Subject: Re: [PATCH 1/4] fdtable: export alloc_fd()
Message-ID: <20090624043926.GN8633@ZenIV.linux.org.uk>
References: <1245317073-24000-1-git-send-email-tj@kernel.org> <1245317073-24000-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245317073-24000-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 06:24:30PM +0900, Tejun Heo wrote:
> Export alloc_fd().  Will be used by FUSE.

Where and how?
