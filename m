Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbZBDXXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbZBDXXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZBDXXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:23:24 -0500
Received: from ozlabs.org ([203.10.76.45]:39830 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961AbZBDXXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:23:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] kernel: constructor support
Date: Thu, 5 Feb 2009 09:53:17 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, Jeff Dike <jdike@addtoit.com>
References: <49883CA9.8030306@linux.vnet.ibm.com> <200902041324.29655.rusty@rustcorp.com.au> <4989AECD.6030009@linux.vnet.ibm.com>
In-Reply-To: <4989AECD.6030009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050953.17985.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 01:35:49 Peter Oberparleiter wrote:
> You're right - this must have slipped in with last minute changes.
> Sorry about that. See fixed patch below (tested successfully with
> modules on s390).

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
