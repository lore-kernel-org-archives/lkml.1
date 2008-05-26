Return-Path: <linux-kernel-owner+w=401wt.eu-S1751644AbYEZEnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbYEZEnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 00:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYEZEmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 00:42:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39761 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYEZEmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 00:42:53 -0400
Date: Mon, 26 May 2008 13:41:49 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 3/3] slob: record page flag overlays explicitly
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1211560412.0@pinky>
References: <exportbomb.1211560342@pinky> <1211560412.0@pinky>
Message-Id: <20080526134123.4667.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> SLOB reuses two page bits for internal purposes, it overlays PG_active
> and PG_private.  This is hidden away in slob.c.  Document these overlays
> explicitly in the main page-flags enum along with all the others.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>

I dont have SLOB box.
but My review found no bug.

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


Thanks.



