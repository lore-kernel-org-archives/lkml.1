Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYAKDqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYAKDqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbYAKDqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:46:25 -0500
Received: from foo.birdnet.se ([213.88.146.6]:41689 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753168AbYAKDqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:46:25 -0500
Message-ID: <20080111034623.4285.qmail@cdy.org>
Date: Fri, 11 Jan 2008 04:46:23 +0100
From: Peter Stuge <stuge-linux-pcmcia@cdy.org>
To: Roel Kluin <12o3l@tiscali.nl>, Al Viro <viro@ZenIV.linux.org.uk>,
       Mathieu Segaud <mathieu.segaud@regala.cx>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Mail-Followup-To: Roel Kluin <12o3l@tiscali.nl>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	Richard Knutsson <ricknu-0@student.ltu.se>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org
References: <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx> <477E379F.4000103@student.ltu.se> <20080105041228.GP3351@webber.adilger.int> <20080105051817.GD27894@ZenIV.linux.org.uk> <4786883E.30604@tiscali.nl> <20080111030945.27954.qmail@cdy.org> <20080111034240.GA29861@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111034240.GA29861@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 12:42:40PM +0900, Paul Mundt wrote:
> How about throwing out hand-rolled debug printk wrappers for the
> brain-damage they are and using the ones the kernel provides
> instead?

Sounds great!


//Peter
