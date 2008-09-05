Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYIEBww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYIEBww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 21:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYIEBwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 21:52:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57813 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYIEBwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 21:52:43 -0400
Date: Fri, 05 Sep 2008 10:52:10 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 3/4] buddy: explicitly identify buddy field use in struct page
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <1220467452-15794-4-git-send-email-apw@shadowen.org>
References: <1220467452-15794-1-git-send-email-apw@shadowen.org> <1220467452-15794-4-git-send-email-apw@shadowen.org>
Message-Id: <20080905105100.5A3E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Explicitly define the struct page fields which buddy uses when it owns
> pages.  Defines a new anonymous struct to allow additional fields to
> be defined in a later patch.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



