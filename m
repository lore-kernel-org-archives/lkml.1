Return-Path: <linux-kernel-owner+w=401wt.eu-S1161850AbXECLtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161850AbXECLtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161854AbXECLtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:49:23 -0400
Received: from ozlabs.org ([203.10.76.45]:39476 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161850AbXECLtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:49:21 -0400
Subject: Re: [LGUEST] Look in object dir for .config
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070503045446.GG15955@bakeyournoodle.com>
References: <20070503045446.GG15955@bakeyournoodle.com>
Content-Type: text/plain
Date: Thu, 03 May 2007 21:49:04 +1000
Message-Id: <1178192945.23670.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 14:54 +1000, Tony Breeds wrote:
> From: Tony Breeds <tony@bakeyournoodle.com>
> 
> [LGUEST] Look in object dir for .config
> 
> If you build with make O=.... then .config isn't in ../../, this patch
> goes partway to making sure that you don't dirty the source tree.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

Thanks Tony.  Will forward to Andrew.

Cheers,
Rusty.

