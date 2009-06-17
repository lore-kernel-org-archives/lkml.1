Return-Path: <linux-kernel-owner+w=401wt.eu-S1764831AbZFQHv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764831AbZFQHv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbZFQHvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:51:48 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53907 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbZFQHvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:51:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Wed, 17 Jun 2009 01:51:37 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 10/17] AFS: Implement the PWhereIs pioctl
In-reply-to: <20090616203937.4526.53619.stgit@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
       Wang Lei <wang840925@gmail.com>
Message-id: <20090617075137.GA13073@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
 <20090616203937.4526.53619.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16, 2009  21:39 +0100, David Howells wrote:
> Implement the PWhereIs pioctl for AFS.  This will find out on which servers
> the volume containing the specified file is located and return the IPv4
> addresses to userspace.

What happens with IPv6?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

