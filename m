Return-Path: <linux-kernel-owner+w=401wt.eu-S934952AbXHNAjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934952AbXHNAjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 20:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759816AbXHNAjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 20:39:12 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3888 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549AbXHNAjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 20:39:10 -0400
Subject: Re: [PATCH] [384/2many] MAINTAINERS - PPP PROTOCOL DRIVERS AND
	COMPRESSORS
From: Joe Perches <joe@perches.com>
To: Paul Mackerras <paulus@samba.org>
Cc: torvalds@linux-foundation.org, linux-ppp@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <18112.61275.563391.321131@cargo.ozlabs.ibm.com>
References: <46bffb62.YUHsMJB9NIlhwots%joe@perches.com>
	 <18112.9870.744182.247752@cargo.ozlabs.ibm.com>
	 <1187019325.10249.74.camel@localhost>
	 <18112.61275.563391.321131@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 17:38:56 -0700
Message-Id: <1187051936.10249.335.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 09:55 +1000, Paul Mackerras wrote:
> It seems poor form to have to rename the file just because of a
> deficiency in the tools.

How about an

X: exclude file pattern

?

