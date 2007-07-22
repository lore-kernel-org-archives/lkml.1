Return-Path: <linux-kernel-owner+w=401wt.eu-S1760370AbXGVHQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370AbXGVHQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 03:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXGVHQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 03:16:07 -0400
Received: from ozlabs.org ([203.10.76.45]:43874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbXGVHQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 03:16:06 -0400
From: Jeremy Kerr <jk@ozlabs.org>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ppc64 mismerge
Date: Sun, 22 Jul 2007 17:14:02 +1000
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
References: <20070722071035.GS21668@ftp.linux.org.uk>
In-Reply-To: <20070722071035.GS21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707221714.07658.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 	Mismerge in
> commit 8b6f50ef1d5cc86b278eb42bc91630fad455fb10
> Author: Jeremy Kerr <jk@ozlabs.org>
> Date:   Sat Jul 21 04:37:51 2007 -0700
>     spufs: make signal-notification files readonly for NOSCHED
> contexts
>
> structs got duplicated.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Yep, the original patch can be applied more than once without fuzz :/

Acked-by: Jeremy Kerr <jk@ozlabs.org>


Jeremy
