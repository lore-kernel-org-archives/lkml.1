Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbZGIKOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbZGIKOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZGIKOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:14:06 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:53216 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZGIKOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZJykEoa3kdYtHhg9+4XMaEwkFXXT3N94or7yq5pKfUz/dtudAgxPfnd9izHWqti+ZX
         jtFbe3/tr5FRQpLBRhfYx9lLV5GEZ8NaUfM3TTQyEvYgSqsU8SXdorUn9P7V/swSudtH
         yGO0VAWxY2lK34hlOpAMhuEiuetQ3ytNzOusk=
MIME-Version: 1.0
In-Reply-To: <20090709170535.23BA.A69D9226@jp.fujitsu.com>
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com>
	 <20090709170535.23BA.A69D9226@jp.fujitsu.com>
Date: Thu, 9 Jul 2009 19:14:04 +0900
Message-ID: <28c262360907090314p466722eeq93384561ab725e94@mail.gmail.com>
Subject: Re: [PATCH 1/5][resend] add per-zone statistics to show_free_areas()
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 5:06 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> Subject: [PATCH] add per-zone statistics to show_free_areas()
>
> show_free_areas() displays only a limited amount of zone counters. This
> patch includes additional counters in the display to allow easier
> debugging. This may be especially useful if an OOM is due to running out
> of DMA memory.
>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
