Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbYFPI06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbYFPI06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYFPI0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:26:50 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48082 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752948AbYFPI0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:26:50 -0400
Date: Mon, 16 Jun 2008 03:26:48 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com, steiner@sgi.com,
       travis@sgi.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 5/8] x86 boot: remap efi systab runtime from phys to
 virt
Message-Id: <20080616032648.88571f0b.pj@sgi.com>
In-Reply-To: <1213604828.12968.7.camel@caritas-dev.intel.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063006.14597.73386.sendpatchset@polaris-admin.engr.sgi.com>
	<1213599759.11185.7.camel@caritas-dev.intel.com>
	<20080616030629.df7afc7a.pj@sgi.com>
	<1213604828.12968.7.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
> I mean the EFI runtime service SetVirtualAddressMap() in spec.

Now I understand your comment.  I will investigate this.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
