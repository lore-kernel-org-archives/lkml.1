Return-Path: <linux-kernel-owner+w=401wt.eu-S933746AbZINUt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746AbZINUt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933688AbZINUt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:49:28 -0400
Received: from fifo99.com ([67.223.236.141]:58068 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933670AbZINUtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:49:23 -0400
Subject: Re: [PATCH 00/72] Blackfin updates for 2.6.32
From: Daniel Walker <dwalker@fifo99.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 13:50:12 -0700
Message-Id: <1252961412.11643.215.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 16:07 -0400, Mike Frysinger wrote:
> Minor highlights:
>  - shadow console to help with really early kernel output
>  - proper decoding of double fault handling
> 
> Otherwise, we've got the normal bug fixes, IPIPE updates, and clean ups.
> 

Patches 15, 16, 20, 21, and 61 all have checkpatch errors some with
several errors..  Could you clean those up those errors before sending
this up stream?

Daniel

