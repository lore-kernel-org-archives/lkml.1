Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbZCaMh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbZCaMh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZCaMhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:37:16 -0400
Received: from THUNK.ORG ([69.25.196.29]:47915 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbZCaMhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:37:14 -0400
Date: Tue, 31 Mar 2009 08:37:10 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] ext4: fix printk format warning in inode.c
Message-ID: <20090331123710.GD13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090331115451.GA3475@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331115451.GA3475@orion>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 03:54:51PM +0400, Alexander Beregalov wrote:
> fs/ext4/inode.c:385: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'long int'
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Thanks, Thiemo has already sent a patch to fix this (as well as
another buglet).

	       	   	   	  	   - Ted
