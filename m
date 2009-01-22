Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbZAVUCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbZAVUCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZAVUCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:02:32 -0500
Received: from kroah.org ([198.145.64.141]:33766 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754370AbZAVUCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:02:32 -0500
Date: Thu, 22 Jan 2009 11:50:12 -0800
From: Greg KH <greg@kroah.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Ext4 tree backports for 2.6.27.10 and 2.6.28
Message-ID: <20090122195012.GA9114@kroah.com>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LOG9D-0006h4-7R@closure.thunk.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 01:43:55PM -0500, Theodore Ts'o wrote:
> 
> I've created a couple of ext4 backport branches which have been uploaded
> to the ext4 git tree:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 
>    http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

Any resolution of ext4 patches to go into the next -stable releases?
I'm pushing out the next review later today, and was wondering what the
status of these were.

thanks,

greg k-h
