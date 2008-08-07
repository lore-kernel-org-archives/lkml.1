Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYHGP17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYHGP17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYHGP1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:27:51 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:55209 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbYHGP1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:27:50 -0400
Date: Fri, 08 Aug 2008 00:27:49 +0900 (JST)
Message-Id: <20080808.002749.25478519.anemo@mba.ocn.ne.jp>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.26.2
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080806175529.GB27119@kroah.com>
References: <20080806175529.GB27119@kroah.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 10:55:29 -0700, Greg KH <gregkh@suse.de> wrote:
> The updated 2.6.26.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=summary

I cannot clone the tree via http protocol.

$ git-clone --reference linux-2.6 http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
Initialized empty Git repository in /home/git/linux-2.6.26.y/.git/
Cannot get remote repository information.
Perhaps git-update-server-info needs to be run there?

I can clone 2.6.25.y tree vit http.

---
Atsushi Nemoto
