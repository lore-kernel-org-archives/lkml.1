Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbZIPAMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbZIPAMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 20:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZIPAMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 20:12:40 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:61037 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbZIPAMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 20:12:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kxM/eKj8NMpeDp7DyqacrJezdFssqNqlcj29uhNo+G6wxj30GLpcEasK45MEpiWKIT
         9WatodsK3gtRT+V69zSSxGyJqRPHAYVsNfkwWAhuLjA+ApCbfirn3Wt9REVn1IjhgAA7
         ldGOEqbKqFlqFSheQJHLu3YpUB9R9zmqjgR9A=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909152206220.28874@sister.anvils>
References: <Pine.LNX.4.64.0909152206220.28874@sister.anvils>
Date: Wed, 16 Sep 2009 09:12:42 +0900
Message-ID: <28c262360909151712k768d7e1s150899162e28daf4@mail.gmail.com>
Subject: Re: [PATCH] hwpoison: fix uninitialized warning
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 6:19 AM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> Fix mmotm build warning, presumably also in linux-next:
> mm/memory.c: In function `do_swap_page':
> mm/memory.c:2498: warning: `pte' may be used uninitialized in this function
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
