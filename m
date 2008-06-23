Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbYFWS3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbYFWS3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbYFWS3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:29:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46626 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbYFWS3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:29:08 -0400
Date: Mon, 23 Jun 2008 12:29:05 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch v3] vfs: fix sys_getcwd for detached mounts
Message-ID: <20080623182905.GI4392@parisc-linux.org>
References: <E1KAqjG-00080e-KH@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KAqjG-00080e-KH@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 08:25:26PM +0200, Miklos Szeredi wrote:
> I tested this one in various situations, and it appears to do what
> it's supposed to.
> 
> A somewhat analogous issue is if we have cwd (or fd) outside
> current->root.  Should we add a prefix for that case as well?  Perhaps
> a double slash?

unreachable: ?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
