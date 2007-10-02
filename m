Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXJBNh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXJBNh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXJBNhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:37:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbXJBNhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:37:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071002122652.GE25647@atrey.karlin.mff.cuni.cz>
References: <20071002122652.GE25647@atrey.karlin.mff.cuni.cz> <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001131028.29339.94415.stgit@warthog.procyon.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: dhowells@redhat.com, hch@infradead.org, viro@ftp.linux.org.uk,
       torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 13/30] IGET: Stop EXT4 from using iget() and read_inode()
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 02 Oct 2007 14:37:15 +0100
Message-ID: <27279.1191332235@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> wrote:

>   Same comments as for ext3 - I think you reversed ext4_test_bit() test
> and also the warning won't be issued in some cases which is wrong.

Same replies as for ext3 too.  Blech.

You should find altered patches landing in your inbox if you'd care to inspect
them.

Thanks,

David
