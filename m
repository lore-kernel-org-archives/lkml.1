Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab0BSBgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 20:36:46 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41460 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab0BSBgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 20:36:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YJiXd10AJa51ck1mgoYQCobrwzZcTxRdtO2A9rmZOH4ncHovXDWdOIRR/4tQ/CFFOK
         Kt2Lo6xt7umRBt3QOu/PX4d/jsFciU01FwIa4QdzkfRNkj3eB5KnuodXWEjvhkkleeaC
         HyvQsC7BgWHrrnHZEffgaXwM+qN9bTKCEf2pg=
MIME-Version: 1.0
In-Reply-To: <1266516162-14154-5-git-send-email-mel@csn.ul.ie>
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie>
	 <1266516162-14154-5-git-send-email-mel@csn.ul.ie>
Date: Fri, 19 Feb 2010 10:36:43 +0900
Message-ID: <28c262361002181736p2b845319yc48844421fd9315@mail.gmail.com>
Subject: Re: [PATCH 04/12] mm: Document /proc/pagetypeinfo
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 3:02 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> This patch adds documentation for /proc/pagetypeinfo.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
