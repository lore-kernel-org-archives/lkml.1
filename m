Return-Path: <linux-kernel-owner+w=401wt.eu-S1762127AbZENC2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127AbZENC2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 22:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZENC1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 22:27:52 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34186 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZENC1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 22:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=cXVlutuT2TF/YUh7tDFCuPXPiDCA2B87qjV6//BENzAMXoN62NAfV93bzcNxnfjpsc
         HoAmBF4oomB14QfQgGSCngV0iEf6cdWQuSGsNPFw333xVPk2gP0ol/emfg1I3kzUlkaZ
         8DpW3oAkiBHNd3rlSX+9nWcFroofa+v5L5Lww=
Date: Thu, 14 May 2009 11:27:31 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <andi@firstfloor.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: =?UTF-8?B?W1BBVENI44CAMS8yXQ==?= remove CONFIG_UNEVICTABLE_LRU
 config option
Message-Id: <20090514112731.8b0c1458.minchan.kim@barrios-desktop>
In-Reply-To: <20090514110357.9B54.A69D9226@jp.fujitsu.com>
References: <20090514110357.9B54.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 11:05:35 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Subject: [PATCH] remove CONFIG_UNEVICTABLE_LRU config option
> 
> Currently, nobody want to turn UNEVICTABLE_LRU off. Thus
> this configurability is unnecessary.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Minchan kim <minchan.kim@gmail.com>

-- 
Kinds Regards
Minchan Kim
