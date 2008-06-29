Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbYF2PSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbYF2PSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 11:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760855AbYF2PR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 11:17:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760724AbYF2PR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 11:17:57 -0400
Date: Sun, 29 Jun 2008 11:17:09 -0400
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm] kill unused lru functions
Message-ID: <20080629111709.2dbdfe6e@bree.surriel.com>
In-Reply-To: <20080629190905.37CF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080629190905.37CF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 19:12:16 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> several LRU manupuration function is not used now.
> So, it can be removed.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
