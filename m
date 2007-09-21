Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbXIUNDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbXIUNDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbXIUNCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:02:52 -0400
Received: from mail.tmr.com ([64.65.253.246]:54330 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbXIUNCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:02:51 -0400
Message-ID: <46F3C1B4.6040804@tmr.com>
Date: Fri, 21 Sep 2007 09:05:56 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
       akpm@linux-foundation.org, yur@emcraft.com, saeed.bishara@gmail.com,
       shannon.nelson@intel.com
Subject: Re: [PATCH 2.6.23-rc7 1/3] async_tx: usage documentation and developer
 notes
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com> <20070921012740.17157.49639.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070921012740.17157.49639.stgit@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>
>  Documentation/crypto/async-tx-api.txt |  217 +++++++++++++++++++++++++++++++++
>  1 files changed, 217 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/crypto/async-tx-api.txt b/Documentation/crypto/async-tx-api.txt
> new file mode 100644
> index 0000000..48d685a
> --- /dev/null
> +++ b/Documentation/crypto/async-tx-api.txt
> @@ -0,0 +1,217 @@
> +		 Asynchronous Transfers/Transforms API
> +
> +1 INTRODUCTION
> +
> +2 GENEALOGY
> +
> +3 USAGE
> +3.1 General format of the API
> +3.2 Supported operations
> +3.2 Descriptor management
> +3.3 When does the operation execute?
> +3.4 When does the operation complete?
> +3.5 Constraints
> +3.6 Example
> +

This is very readable, and appears extensible to any new forthcoming 
technology I'm aware of. Great job!

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

