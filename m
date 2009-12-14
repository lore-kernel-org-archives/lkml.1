Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbZLNWwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbZLNWwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbZLNWwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:52:10 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:43968 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbZLNWwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=OkKMKU+VSMBMu/PZCvNHZVDXGBcfJlUrhVh5OxnnXCMoxtg+qrS/ZqIWtYuo1mwKC2
         5zX+2BQUldLNWHGCI7hd9oqKkEZcQaheObOlvxe9hyivQz6lO5vPNAtduUGGLBUJR8dV
         42pnQLvqGcZ4fGb8aLpn9iJF86cMkg+tli+Mw=
Date: Tue, 15 Dec 2009 07:39:22 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [cleanup][PATCH 1/8] vmscan: Make shrink_zone_begin/end helper
 function
Message-Id: <20091215073922.494c3e66.minchan.kim@barrios-desktop>
In-Reply-To: <20091214212308.BBB1.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com>
	<20091214210823.BBAE.A69D9226@jp.fujitsu.com>
	<20091214212308.BBB1.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 21:23:46 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> concurrent_reclaimers limitation related code made mess to shrink_zone.
> To introduce helper function increase readability.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Through looking over patch series, it's nice clean up.

-- 
Kind regards,
Minchan Kim
