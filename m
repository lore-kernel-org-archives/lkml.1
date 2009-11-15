Return-Path: <linux-kernel-owner+w=401wt.eu-S1751736AbZKOBx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbZKOBx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 20:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZKOBx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 20:53:56 -0500
Received: from thunk.org ([69.25.196.29]:38463 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZKOBxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 20:53:55 -0500
Date: Sat, 14 Nov 2009 20:53:52 -0500
From: Theodore Tso <tytso@mit.edu>
To: Julia Lawall <julia@diku.dk>
Cc: sandeen@redhat.com, cmm@us.ibm.com, Andreas Dilger <adilger@sun.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] fs/ext4: test the i_flags field of the right structure
Message-ID: <20091115015352.GA4323@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Julia Lawall <julia@diku.dk>, sandeen@redhat.com, cmm@us.ibm.com,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0911022158190.4930@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911022158190.4930@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 09:58:47PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Elsewhere, EXT4_EXTENTS_FL is combined with EXT4_I(inode)->i_flags, rather
> than inode->i_flags.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied to the ext4 patch queue, thanks.

							- Ted
