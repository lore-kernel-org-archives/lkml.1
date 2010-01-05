Return-Path: <linux-kernel-owner+w=401wt.eu-S932121Ab0AETF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab0AETF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769Ab0AETF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:05:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab0AETFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:05:44 -0500
Date: Tue, 5 Jan 2010 10:56:55 -0800
From: Greg KH <gregkh@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 83/97] ext4: Fix potential quota deadlock
Message-ID: <20100105185655.GB15630@suse.de>
References: <20100105003133.GA7199@kroah.com>
 <1262651630-7354-83-git-send-email-gregkh@suse.de>
 <20100105004741.GD3252@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105004741.GD3252@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 01:47:42AM +0100, Jan Kara wrote:
> On Mon 04-01-10 16:33:36, Greg Kroah-Hartman wrote:
> > From: Dmitry Monakhov <dmonakhov@openvz.org>
> > 
> > commit d21cd8f163ac44b15c465aab7306db931c606908 upstream.
>   Ted has found a serious bug in this patch over Christmas and fixed it.
> Ted, do you prefer to just discard this patch or will you add your fixes?

Do you have the git commit id of the patch that fixes it?

thanks,

greg k-h
