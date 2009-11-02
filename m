Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbZKBXDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbZKBXDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbZKBXDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:03:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40865 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163AbZKBXDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:03:39 -0500
Message-ID: <b315dd26d62d266a58e97e1a17791249.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0911021206410.2028@V090114053VZO-1>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
    <20091102162526.c985c5a8.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.1.10.0911021206410.2028@V090114053VZO-1>
Date: Tue, 3 Nov 2009 08:03:40 +0900 (JST)
Subject: Re: [RFC][-mm][PATCH 2/6] oom-killer: count swap usage per process.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       aarcange@redhat.com, akpm@linux-foundation.org, minchan.kim@gmail.com,
       rientjes@google.com, vedran.furac@gmail.com,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>
> Submit this patch independently? I think it is generally useful.
>
Thanks, I will do so.

Regards,
-Kame

