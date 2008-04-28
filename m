Return-Path: <linux-kernel-owner+w=401wt.eu-S936548AbYD1TqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936548AbYD1TqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932155AbYD1TqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:46:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45452 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbYD1TqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:46:09 -0400
Message-ID: <48162965.5030003@zytor.com>
Date: Mon, 28 Apr 2008 12:45:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Markus Metzger <markus.t.metzger@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: DS cleanup - dont treat 0 as NULL
References: <20080428191504.GA6842@cvg>
In-Reply-To: <20080428191504.GA6842@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Actually I wonder why in original code Atom processors was
> _that_ aligned? Was it made with a special purpose? yes,
> it's a mobile platform, but can't see any reason for such
> alignment.
> 

I'm sorry, I don't see how this comment has anything to do with this patch?

	-hpa
