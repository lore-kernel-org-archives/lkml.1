Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbYAKPnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbYAKPnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760440AbYAKPnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:43:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760033AbYAKPnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:43:11 -0500
Date: Fri, 11 Jan 2008 10:42:58 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080111104258.2d1df3de@bree.surriel.com>
In-Reply-To: <20080111143627.FD64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080108205939.323955454@redhat.com>
	<20080108210002.638347207@redhat.com>
	<20080111143627.FD64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 15:24:34 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> below patch is a bit cleanup proposal.
> i think LRU_FILE is more clarify than "/2".
> 
> What do you think it?

Thank you for the cleanup, your version looks a lot nicer.  
I have applied your patch to my series.

-- 
All rights reversed.
