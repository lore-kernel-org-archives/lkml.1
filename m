Return-Path: <linux-kernel-owner+w=401wt.eu-S1763796AbYD3UMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763796AbYD3UMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbYD3UM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:12:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58893 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbYD3UM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:12:27 -0400
Message-ID: <4818D12A.6070905@zytor.com>
Date: Wed, 30 Apr 2008 13:06:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Mail problems at hera.kernel.org
References: <20080430172129.GA29330@cs181133002.pp.htv.fi>
In-Reply-To: <20080430172129.GA29330@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Sorry for the semi-OT, but this seems to be the easiest way without 
> using any @kernel.org address in the To: header:

Or you could have said something on #korg (LinuxNet), or emailed any of 
the admins directly.

> Since yesterday evening hera (the machine handling emails to @kernel.org) 
> seems to no longer accept emails, vger alone has currently over 1300 
> emails queued for hera [1] and SMTP locally from hera also doesn't work.
> 
> Could some admin look at it?

Fixed it quite a bit ago, long before I saw this post.

FWIW, clamav had gone catatonic.

	-hpa
