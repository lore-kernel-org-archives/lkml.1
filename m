Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbYBSNfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbYBSNfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYBSNez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:34:55 -0500
Received: from relay1.sgi.com ([192.48.171.29]:55880 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751899AbYBSNey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:34:54 -0500
Date: Tue, 19 Feb 2008 07:34:50 -0600
From: Paul Jackson <pj@sgi.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, clameter@sgi.com,
       menage@google.com, kosaki.motohiro@jp.fujitsu.com
Subject: Re: cpuset trivial documentation fix s/N_MEMORY/N_HIGH_MEMORY/
Message-Id: <20080219073450.7479cb00.pj@sgi.com>
In-Reply-To: <20080219193503.94A0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080219193503.94A0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI-san wrote:
> +++ b/Documentation/cpusets.txt 2008-02-19 19:37:14.000000000 +0900
> ...
> -automatically tracks the value of node_states[N_MEMORY]--i.e.,
> +automatically tracks the value of node_states[N_HIGH_MEMORY]--i.e.,

Thanks.

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
