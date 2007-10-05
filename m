Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbXJEOrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbXJEOrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 10:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbXJEOro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 10:47:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40887 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731AbXJEOrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 10:47:43 -0400
Date: Fri, 5 Oct 2007 15:47:39 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/32] IGET: Mark iget() and read_inode() as being obsolete [try #2]
Message-ID: <20071005144739.GC3072@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
	torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk> <20071004155632.2814.55633.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004155632.2814.55633.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why do you move it out of line?
