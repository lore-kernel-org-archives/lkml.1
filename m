Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbYB1W2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbYB1W2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYB1W2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:28:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbYB1W17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:27:59 -0500
Date: Thu, 28 Feb 2008 17:27:39 -0500
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [patch 21/21] cull non-reclaimable anon pages from the LRU at
 fault time
Message-ID: <20080228172739.61fc3780@bree.surriel.com>
In-Reply-To: <1204229973.5301.34.camel@localhost>
References: <20080228192908.126720629@redhat.com>
	<20080228192929.793021800@redhat.com>
	<1204229973.5301.34.camel@localhost>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 15:19:33 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> On Thu, 2008-02-28 at 14:29 -0500, Rik van Riel wrote:
> 
> corrections to description in case we decide to keep this patch.

Thanks.  I have merged your new description.

-- 
All rights reversed.
