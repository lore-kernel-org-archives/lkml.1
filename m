Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYGaGKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYGaGKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 02:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYGaGKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 02:10:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbYGaGKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:10:43 -0400
Date: Wed, 30 Jul 2008 23:10:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
Message-Id: <20080730231029.9818953c.akpm@linux-foundation.org>
In-Reply-To: <20080730170635.f737ffe9.sfr@canb.auug.org.au>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 17:06:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

The X server broke on my FC8 t61p thinkpad.  Mainline is OK.

Various information is at http://userweb.kernel.org/~akpm/mo/

I'm suspecting the input layer - my synaptics device seems to have
disappeared?  See http://userweb.kernel.org/~akpm/mo/Xorg-log-diff.txt


