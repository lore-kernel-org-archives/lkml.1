Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYHHWXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYHHWXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760678AbYHHWXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:23:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760376AbYHHWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:23:35 -0400
Message-ID: <489CC75E.9090400@kernel.org>
Date: Fri, 08 Aug 2008 15:23:26 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [0/4] Updates to the x86 machine check unification
References: <20080805717.971524000@firstfloor.org>
In-Reply-To: <20080805717.971524000@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Should be applied to the respective x86 topic branch.
> 
> - Fix Intel thermal handling broken in earlier merge
> - Add old code to the deprecation schedule
> - Fix a long standing bug in thermal interrupt handling after
> suspend to ram 
> - Revert older bogus patch
> 

Applied to tip:x86/unify-mce, thanks.

	-hpa
