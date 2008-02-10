Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbYBJGdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbYBJGdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 01:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYBJGdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 01:33:06 -0500
Received: from 1wt.eu ([62.212.114.60]:1798 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbYBJGdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 01:33:03 -0500
Date: Sun, 10 Feb 2008 07:32:48 +0100
From: Willy Tarreau <w@1wt.eu>
To: Niki Denev <ndenev@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
Message-ID: <20080210063247.GQ8953@1wt.eu>
References: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 08:04:35AM +0200, Niki Denev wrote:
> Hi,
> 
> As the subject says the 2.6.24.1 is still vulnerable to the vmsplice
> local root exploit.

Yes indeed, that's quite bad. 2.6.24-git is still vulnerable too, and
also contains the fix :-(

CC'd Jens as he worked on the fix.

Willy

