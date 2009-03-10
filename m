Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbZCJSxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbZCJSxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbZCJSxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:53:37 -0400
Received: from kroah.org ([198.145.64.141]:36574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755724AbZCJSxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:53:36 -0400
Date: Tue, 10 Mar 2009 11:25:56 -0700
From: Greg KH <greg@kroah.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Asking for inclusion of nilfs2 in the mainline kernel
Message-ID: <20090310182556.GA5730@kroah.com>
References: <20090311.015542.118514963.ryusuke@osrg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311.015542.118514963.ryusuke@osrg.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 01:55:42AM +0900, Ryusuke Konishi wrote:
> Hi, 
> 
> I've been working for the past serveral months to take review comments
> and to continually solve users' problems come up in mainling list
> (thanks for all giving comments and feedbacks!).  Also, I've tried to
> stabilize API and disk format to restrict additional changes and
> ensure backward compatibility.
> 
> Except adding ioctl commands for user-demanded features, I think the
> interface was almost stabilized.  Now I'd like to ask for mainline
> inclusion so that more people can try this in the tree.

Then submit some patches, as documented in
Documentation/SubmittingPatches :)

thanks,

greg k-h
