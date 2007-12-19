Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbXLSPoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbXLSPoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbXLSPoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:44:04 -0500
Received: from saeurebad.de ([85.214.36.134]:37403 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600AbXLSPoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:44:03 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Bodo Eggert <7eggert@gmx.de>, Mark Lord <lkml@rtr.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
References: <9BTqk-2ck-31@gated-at.bofh.it> <9BTJN-2Sv-21@gated-at.bofh.it>
	<9BTTr-35L-13@gated-at.bofh.it>
	<E1J4zCp-0003fj-5I@be1.7eggert.dyndns.org>
	<20071219142351.GI8181@ftp.linux.org.uk>
Date: Wed, 19 Dec 2007 16:42:32 +0100
In-Reply-To: <20071219142351.GI8181@ftp.linux.org.uk> (Al Viro's message of
	"Wed, 19 Dec 2007 14:23:51 +0000")
Message-ID: <x7k5na1yjb.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Al Viro <viro@ftp.linux.org.uk> writes:

> On Wed, Dec 19, 2007 at 02:43:26PM +0100, Bodo Eggert wrote:
>
>> Since nobody knows about this "security boundary" and everybody knows about
>> the annoying "can't link across bind-mountpoints bug",
>
> ... how about teaching people to RTFM?  Starting, perhaps, with man 2
> link?

Making people RTFM?  Are you trippin? ;)

But in the sense of providing mechanism not (only) policy, a mount
option for that behaviour would still be nice.

	Hannes
