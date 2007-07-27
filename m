Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbXG0Qu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbXG0Qu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 12:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXG0Qur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 12:50:47 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:61754 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753157AbXG0Quq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 12:50:46 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: Jeff Dike <jdike@addtoit.com>
Cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/68] 0 -> NULL, for arch/um
References: <200707270945.LAA17372@ifs.emn.fr>
	<20070727163541.GA6930@c2.user-mode-linux.org>
Date: Fri, 27 Jul 2007 18:49:54 +0200
In-Reply-To: <20070727163541.GA6930@c2.user-mode-linux.org> (Jeff Dike's
	message of "Fri, 27 Jul 2007 12:35:41 -0400")
Message-ID: <871wet7pvx.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike <jdike@addtoit.com> writes:

> On Fri, Jul 27, 2007 at 11:45:56AM +0200, Yoann Padioleau wrote:
>> When comparing a pointer, it's clearer to compare it to NULL than to 0.
>
> ACK
>
>>  sys-i386/fault.c   |    2 +-
>>  sys-x86_64/fault.c |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> Except you should probably diff from the top of the kernel tree.

Sorry. I will use diffstat -p1  from now on.

>
> 				Jeff
>
> -- 
> Work email - jdike at linux dot intel dot com

