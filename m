Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbZKBAtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbZKBAtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 19:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZKBAtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 19:49:02 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:53999 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbZKBAtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 19:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=fiJaEvSV8IkbK7gFKtofg9mdkvoGTOsxKya6zIt8oa/8pseqMngLAII/tbikGMd+9r
         YKL7cwlmHSFhourinpUxKSn2ombYbUJ+jGgJES0mmdtcLuJySGtYpskhbGAjONcpxEsh
         plsWh3npdnB0QmbXsZ4jVtHzIoWUUSK2vsHF4=
Date: Mon, 2 Nov 2009 09:46:30 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 4/5] vmscan: Kill sc.swap_cluster_max
Message-Id: <20091102094630.9b006e3f.minchan.kim@barrios-desktop>
In-Reply-To: <20091102001110.F40A.A69D9226@jp.fujitsu.com>
References: <20091101234614.F401.A69D9226@jp.fujitsu.com>
	<20091102001110.F40A.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 00:12:02 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Now, all caller is settng to swap_cluster_max = SWAP_CLUSTER_MAX.
> Then, we can remove it perfectly.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
