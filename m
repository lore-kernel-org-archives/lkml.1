Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbZKAR46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbZKAR46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 12:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZKAR46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 12:56:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbZKAR45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 12:56:57 -0500
Message-ID: <4AEDCBE3.6030407@redhat.com>
Date: Sun, 01 Nov 2009 12:56:51 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 4/5] vmscan: Kill sc.swap_cluster_max
References: <20091101234614.F401.A69D9226@jp.fujitsu.com> <20091102001110.F40A.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091102001110.F40A.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 10:12 AM, KOSAKI Motohiro wrote:
> Now, all caller is settng to swap_cluster_max = SWAP_CLUSTER_MAX.
> Then, we can remove it perfectly.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
