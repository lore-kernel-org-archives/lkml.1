Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYIDBZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYIDBZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 21:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYIDBYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 21:24:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458AbYIDBYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 21:24:54 -0400
Date: Wed, 3 Sep 2008 21:25:22 -0400
From: Rik van Riel <riel@redhat.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 3/4] buddy: explicitly identify buddy field use in
 struct page
Message-ID: <20080903212522.04ab412e@riellaptop.surriel.com>
In-Reply-To: <1220467452-15794-4-git-send-email-apw@shadowen.org>
References: <1220467452-15794-1-git-send-email-apw@shadowen.org>
	<1220467452-15794-4-git-send-email-apw@shadowen.org>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Sep 2008 19:44:11 +0100
Andy Whitcroft <apw@shadowen.org> wrote:

> Explicitly define the struct page fields which buddy uses when it owns
> pages.  Defines a new anonymous struct to allow additional fields to
> be defined in a later patch.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
