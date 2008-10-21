Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYJUBWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYJUBWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 21:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYJUBWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 21:22:21 -0400
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:2984 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbYJUBWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 21:22:21 -0400
Message-ID: <48FD2EA8.2020300@lougher.demon.co.uk>
Date: Tue, 21 Oct 2008 02:21:44 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 00/16] Squashfs: compressed read-only	filesystem
References: <E1KqrTW-0001x8-3h@dylan> <1224268027.18940.78.camel@moss-terrapins.epoch.ncsc.mil>
In-Reply-To: <1224268027.18940.78.camel@moss-terrapins.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:
  In SELinux and
> other LSMs symlinks and directories are also labeled so they will need
> xattr entries.

BTW you don't mention device, fifo and socket inodes...  Do they ever 
get labelled?  It's something I was going to look into closer to an 
implementation, but it would be interesting to know.

Phillip

> 
> Dave
> 
> 

