Return-Path: <linux-kernel-owner+w=401wt.eu-S1763091AbZEGUvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763091AbZEGUvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZEGUu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:50:59 -0400
Received: from sous-sol.org ([216.99.217.87]:52681 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752591AbZEGUu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:50:58 -0400
Date: Thu, 7 May 2009 13:50:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Avi Kivity <avi@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Message-ID: <20090507205035.GH3036@sequoia.sous-sol.org>
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <200905072200.22007.arnd@arndb.de> <4A03451E.9020304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A03451E.9020304@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (gregory.haskins@gmail.com) wrote:
> After posting my numbers today, what I *can* tell you definitively that
> its significantly slower to VMEXIT via MMIO.  I guess I do not really
> know the reason for sure. :)

there's certainly more work, including insn decoding
