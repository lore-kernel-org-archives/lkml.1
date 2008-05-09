Return-Path: <linux-kernel-owner+w=401wt.eu-S1762249AbYEIPu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762249AbYEIPu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYEIPuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:50:46 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43733 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbYEIPup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:50:45 -0400
Date: Fri, 9 May 2008 11:50:40 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/9] file locking fixes + fuse nfs export support
Message-ID: <20080509155040.GB798@fieldses.org>
References: <20080509124107.645600519@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509124107.645600519@szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A separate question--does the problem you reported with interrupted lock
requests still exist?

On Fri, May 09, 2008 at 02:41:07PM +0200, Miklos Szeredi wrote:
> Patches 1-4 are file locking API changes required for the rest of the
> patches.
> 
> Patches 5-9 add nfs exporting support for fuse filesystems.

Neat, thanks for working on this.

--b.

> This is for 2.6.27.
