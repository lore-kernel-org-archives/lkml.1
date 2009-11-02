Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZKBAuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZKBAuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 19:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZKBAuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 19:50:55 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59648 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZKBAuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 19:50:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=wkXAB0RBbhE+ocf/18qAVFpQ1g6IIZXBuPy1Ptie5ktQ77Axw3vvUc0HSgZapk/LQ8
         /9ZIu+D9fFldJ2HQiVuUobDNB/Jv+BEwJT93+rQM0Mbgrqag47UxTu1z7s5vHmjwR2bD
         A+xcyZDulDQhKcRCuHnun4XkdFZ9S0D1q8n3o=
Date: Mon, 2 Nov 2009 09:48:25 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 5/5][nit fix] vmscan Make consistent of reclaim bale
 out between do_try_to_free_page and shrink_zone
Message-Id: <20091102094825.50af0708.minchan.kim@barrios-desktop>
In-Reply-To: <20091102001210.F40D.A69D9226@jp.fujitsu.com>
References: <20091101234614.F401.A69D9226@jp.fujitsu.com>
	<20091102001210.F40D.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 00:13:04 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Fix small inconsistent of ">" and ">=".
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
