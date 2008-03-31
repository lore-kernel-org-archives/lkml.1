Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYCaXAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYCaXAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 19:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYCaXAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 19:00:33 -0400
Received: from oss.sgi.com ([192.48.170.157]:39208 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbYCaXAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:00:32 -0400
X-Greylist: delayed 1123 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Mar 2008 19:00:32 EDT
Date: Mon, 31 Mar 2008 23:41:43 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] [MIPS] make some functions and variables static
Message-ID: <20080331224143.GA28473@linux-mips.org>
References: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 02:03:19AM +0400, Dmitri Vorobiev wrote:

> I noticed that a few functions and variables in the MIPS-specific
> code can become static, and this series of patches cleans up the
> kernel global name space a little bit.

I've queued the whole series for 2.6.26.

Thanks,

  Ralf
