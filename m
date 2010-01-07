Return-Path: <linux-kernel-owner+w=401wt.eu-S932849Ab0AGBwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab0AGBwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932650Ab0AGBw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:52:28 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:38825 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543Ab0AGBw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:52:27 -0500
Date: Wed, 6 Jan 2010 17:51:44 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 7/8] fs/ocfs2/cluster/tcp.c: Remove use of NIPQUAD, use
 %pI4
Message-ID: <20100107015144.GB20095@mail.oracle.com>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	ocfs2-devel@oss.oracle.com
References: <cover.1262726222.git.joe@perches.com>
 <ec11c9ed70064e4f1137da23e51171a3620943f6.1262726222.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec11c9ed70064e4f1137da23e51171a3620943f6.1262726222.git.joe@perches.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B453E55.013C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 05:20:19PM -0800, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Joel Becker <joel.becker@oracle.com>


-- 

The Graham Corollary:

	The longer a socially-moderated news website exists, the
	probability of an old Paul Graham link appearing at the top
	approaches certainty.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
