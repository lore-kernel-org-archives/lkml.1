Return-Path: <linux-kernel-owner+w=401wt.eu-S935707AbYGCHNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935707AbYGCHNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYGCG6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:32 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:36546 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754910AbYGCFsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 01:48:06 -0400
Date: Thu, 3 Jul 2008 14:45:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sh-asm/unistd.h userspace cleanup
Message-ID: <20080703054521.GA31673@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Khem Raj <raj.khem@gmail.com>, linux-kernel@vger.kernel.org
References: <486C159C.4020108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486C159C.4020108@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 04:56:12PM -0700, Khem Raj wrote:
> Hi,
> 
> CONFIG_SUPERH32 is currently trickling into userspace unistd.h. Attached patch uses __SH5__define  in userspace.
> 
> Thanks
> 
> -Khem
> 
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> 
Applied, thanks.
