Return-Path: <linux-kernel-owner+w=401wt.eu-S1765837AbYEUS72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765837AbYEUS72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759987AbYEUS6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:58:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936032AbYEUS6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:58:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080521174231.GH15355@cs181133002.pp.htv.fi>
References: <20080521174231.GH15355@cs181133002.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] don't offer BINFMT_FLAT on frv
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 21 May 2008 19:56:27 +0100
Message-ID: <7211.1211396187@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looks fine, though I can't test it till next week.

Acked-by: David Howells <dhowells@redhat.com>
