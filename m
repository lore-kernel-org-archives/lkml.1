Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbYCMQBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbYCMQBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYCMQBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:01:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39292 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYCMQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:01:39 -0400
Date: Thu, 13 Mar 2008 08:55:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Add a document describing the resource counter
 abstraction (v2)
Message-Id: <20080313085510.8c318a58.randy.dunlap@oracle.com>
In-Reply-To: <47D8F561.4000004@openvz.org>
References: <47D8F561.4000004@openvz.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 12:35:29 +0300 Pavel Emelyanov wrote:

> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/Documentation/controllers/resource_counter.txt b/Documentation/controllers/resource_counter.txt
> new file mode 100644
> index 0000000..563000d
> --- /dev/null
> +++ b/Documentation/controllers/resource_counter.txt
> @@ -0,0 +1,181 @@
> +
> +5. Usage example
> +
> + c. Provide the way to read res_counter values and set them (the cgroups
> +    still can help with it).
> +
> + c. Compile and run :)

s/c./d./ or c'.  :)

Otherwise looks good.  Thanks.

---
~Randy
