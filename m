Return-Path: <linux-kernel-owner+w=401wt.eu-S1767507AbXCITZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767507AbXCITZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767508AbXCITZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:25:17 -0500
Received: from mxout-03.mxes.net ([216.86.168.178]:3138 "EHLO
	mxout-03.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767507AbXCITZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:25:15 -0500
Message-ID: <33730.86.7.220.119.1173468314.squirrel@wmbeta.mxes.net>
In-Reply-To: <200703081828.33606.lenb@kernel.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
    <20070305015039.GI3441@stusta.de> <1173090919.6782.13.camel@daplas>
    <200703081828.33606.lenb@kernel.org>
Date: Fri, 9 Mar 2007 19:25:14 -0000 (GMT)
Subject: Re: [4/6] 2.6.21-rc2: known regressions
From: "Andrew" <andrew@nelless.net>
To: "Len Brown" <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org
Reply-To: "Andrew" <andrew@nelless.net>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, March 8, 2007 11:28 pm, Len Brown wrote:
> On Monday 05 March 2007 05:35, Antonino A. Daplas wrote:
>
>
> Looks like I got fooled by the negative logic for the nvidia_bugs().
> Please test this patch -- it should fix it,
> as well as simplify the code a bit.
>
> thanks, -Len
>

Yep. You can knock this one off the regression
list :)

Thanks,
  Andrew


