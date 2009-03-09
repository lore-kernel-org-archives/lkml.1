Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZCIIa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZCIIa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZCIIaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:30:16 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:48728 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbZCIIaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:30:15 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [Aufs 02/25] aufs public header file 
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090309055030.GB14122@uranus.ravnborg.org>
References: <1236569118-3750-1-git-send-email-hooanon05@yahoo.co.jp> <1236569118-3750-3-git-send-email-hooanon05@yahoo.co.jp> <20090309055030.GB14122@uranus.ravnborg.org>
Date: Mon, 09 Mar 2009 17:30:09 +0900
Message-ID: <9910.1236587409@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sam Ravnborg:
> >  include/linux/aufs_type.h |   98 +++++++++++++++++++++++++++++++++++++++++++++
> 
> Why does it live in include/linux?
> If it is part of the userspace ABI it should be included in Kbuild.

It contains ioctl commands and other macros for userspace.
I will add this file in include/linux/Kbuild.

Thank you
J. R. Okajima
