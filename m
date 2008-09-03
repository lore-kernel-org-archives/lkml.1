Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYICUhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYICUhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbYICUhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:37:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbYICUhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:37:07 -0400
Message-ID: <48BEF55E.700@linux-foundation.org>
Date: Wed, 03 Sep 2008 15:36:46 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/4] buddy: explicitly identify buddy field use in struct
 page
References: <1220467452-15794-1-git-send-email-apw@shadowen.org> <1220467452-15794-4-git-send-email-apw@shadowen.org>
In-Reply-To: <1220467452-15794-4-git-send-email-apw@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Explicitly define the struct page fields which buddy uses when it owns
> pages.  Defines a new anonymous struct to allow additional fields to
> be defined in a later patch.

Good. I have a similar patch floating around.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
