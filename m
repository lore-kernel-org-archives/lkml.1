Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYBIH5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYBIH5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 02:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYBIH53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 02:57:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41680 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbYBIH52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 02:57:28 -0500
Date: Sat, 9 Feb 2008 07:57:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@lst.de, viro@ftp.linux.org.uk,
       miklos@szeredi.hu
Subject: Re: [RFC][PATCH 00/30] Read-only bind mounts (-mm resend)
Message-ID: <20080209075723.GF27894@ZenIV.linux.org.uk>
References: <20080208222641.6024A7CC@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208222641.6024A7CC@kernel>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 02:26:41PM -0800, Dave Hansen wrote:
> This is against current Linus git
> (a4ffc0a0b240a29cbe489f6db9dae112a49ef1c1).
> 
> This rolls up all the -mm bugfixes that were accumulated, and
> addresses some new review comments from Al.  Also contains some
> reworking from hch and a patch from Jeff Dike.
> 
> Just posting here to let everyone have a sniff before we resend
> it back to -mm.

ACKed.
