Return-Path: <linux-kernel-owner+w=401wt.eu-S1163288AbXD1SWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163288AbXD1SWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163330AbXD1SWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:22:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163288AbXD1SWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:22:21 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] i386: introduce voyager smp_ops, fix voyager build
Date: Sat, 28 Apr 2007 20:22:11 +0200
User-Agent: KMail/1.9.6
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <463382E5.9060701@goop.org>
In-Reply-To: <463382E5.9060701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704282022.11321.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 April 2007 19:22:45 Jeremy Fitzhardinge wrote:
> This adds an smp_ops for voyager, and hooks things up appropriately.
> This is the first baby-step to making subarch runtime switchable.

James, does it actually work?


-Andi
