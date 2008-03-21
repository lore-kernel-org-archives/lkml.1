Return-Path: <linux-kernel-owner+w=401wt.eu-S1761556AbYCUUSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556AbYCUUSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbYCUUSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:18:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41624 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbYCUUSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:18:36 -0400
Message-ID: <47E41805.5090602@zytor.com>
Date: Fri, 21 Mar 2008 13:18:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: relocate_kernel - use predefined PAGE_SIZE instead
 of	own alias
References: <20080321201214.GA9424@cvg>
In-Reply-To: <20080321201214.GA9424@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> This patch does clean up relocate_kernel_(32|64).S a bit by getting rid
> of local PAGE_ALIGNED macro. We should use well-known PAGE_SIZE instead
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Looks good!

	-hpa
