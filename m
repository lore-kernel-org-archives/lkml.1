Return-Path: <linux-kernel-owner+w=401wt.eu-S1031882AbXHMQbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031882AbXHMQbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942462AbXHMPfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:35:43 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3047 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S944206AbXHMPfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:35:39 -0400
Subject: Re: [PATCH] [384/2many] MAINTAINERS - PPP PROTOCOL DRIVERS AND
	COMPRESSORS
From: Joe Perches <joe@perches.com>
To: Paul Mackerras <paulus@samba.org>
Cc: torvalds@linux-foundation.org, linux-ppp@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <18112.9870.744182.247752@cargo.ozlabs.ibm.com>
References: <46bffb62.YUHsMJB9NIlhwots%joe@perches.com>
	 <18112.9870.744182.247752@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 08:35:25 -0700
Message-Id: <1187019325.10249.74.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 19:38 +1000, Paul Mackerras wrote:
> Except for drivers/net/ppp_synctty.c.

It seems poor form to have 5 file entries where 1 would do.

Would renaming this one file to pppsynctty.c work?

