Return-Path: <linux-kernel-owner+w=401wt.eu-S1751292AbXDDQ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbXDDQ6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXDDQ6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:58:15 -0400
Received: from ns.suse.de ([195.135.220.2]:35640 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbXDDQ6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:58:14 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 1/6] Re-enable VDSO by default with PARAVIRT
Date: Wed, 4 Apr 2007 18:57:54 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
References: <20070404010655.400913479@goop.org> <20070404011453.193215073@goop.org>
In-Reply-To: <20070404011453.193215073@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704041857.54535.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 03:06:56 Jeremy Fitzhardinge wrote:
> Everyone wants VDSO to be enabled by default.  COMPAT_VDSO still needs
> a fix, but with luck that will turn up soon.

Hmm, that would break at least my test system until Jan's patch is applied.

-Andi
