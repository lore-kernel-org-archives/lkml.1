Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbYE2EUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbYE2EUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 00:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbYE2EUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 00:20:25 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:44575 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750853AbYE2EUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 00:20:24 -0400
Date: Thu, 29 May 2008 13:18:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sh: module.c use kernel unaligned helpers
Message-ID: <20080529041841.GC12619@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <1212017897.20781.6.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212017897.20781.6.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 04:38:17PM -0700, Harvey Harrison wrote:
> Replace the COPY_UNALIGNED_WORD helper.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Looks good, I'll add it to my queue, thanks.
