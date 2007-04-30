Return-Path: <linux-kernel-owner+w=401wt.eu-S1946306AbXD3Q0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946306AbXD3Q0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423570AbXD3Q0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:26:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:37674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946402AbXD3QZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:25:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 06/12] i386: Minimum cpu detection cleanups.
Date: Mon, 30 Apr 2007 18:19:31 +0200
User-Agent: KMail/1.9.6
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com> <m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com> <m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301819.31618.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 18:09:11 Eric W. Biederman wrote:
> 
> This patch modifies verify_cpu to check for a 486 even when
> REQUIRED_MASK1 == 0 

Merged into the original patch thanks

-Andi
