Return-Path: <linux-kernel-owner+w=401wt.eu-S934165AbZLJLwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165AbZLJLwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 06:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934076AbZLJLwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 06:52:08 -0500
Received: from ozlabs.org ([203.10.76.45]:37024 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934079AbZLJLwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 06:52:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH v2] modpost: fix asprintf warnings
Date: Thu, 10 Dec 2009 22:22:04 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20091209155903.GB3247@hack> <1260407779-12517-1-git-send-email-vapier@gentoo.org> <200912102137.52347.rusty@rustcorp.com.au>
In-Reply-To: <200912102137.52347.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912102222.04822.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 09:37:52 pm Rusty Russell wrote:
> On Thu, 10 Dec 2009 11:46:19 am Mike Frysinger wrote:
> > On compilers with security warnings enabled by default, we get:
> > 
> > scripts/mod/modpost.c: In function 'get_markers':
> > scripts/mod/modpost.c:1562: warning: ignoring return value of 'asprintf',
...
> Applied,
> Rusty.

Actually, not applied since another patch in my queue deletes that obsolete
code altogether.

Thanks,
Rusty.
