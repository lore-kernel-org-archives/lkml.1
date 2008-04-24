Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYDXL3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYDXL3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYDXL3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:29:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbYDXL3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:29:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200804231458.53282.rgetz@blackfin.uclinux.org>
References: <200804231458.53282.rgetz@blackfin.uclinux.org> <200804221356.15748.rgetz@blackfin.uclinux.org> <8682.1208900110@redhat.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: dhowells@redhat.com, "Greg Ungerer" <gerg@snapgear.com>,
       linux-kernel@vger.kernel.org, "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH] mm/nommu.c - return 0 from kobjsize with invalid objects
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 24 Apr 2008 12:28:11 +0100
Message-ID: <10954.1209036491@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> Don't perform kobjsize operations on objects the kernel doesn't manage.
> 
> Signed-off-by: Michael Hennerich <Michael.Hennerich@analog.com>
> Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>

Acked-by: David Howells <dhowells@redhat.com>
