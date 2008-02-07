Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbYBGBgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbYBGBgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 20:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761255AbYBGBgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 20:36:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761144AbYBGBgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 20:36:39 -0500
Date: Wed, 6 Feb 2008 20:36:20 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080206203620.1a4e5b48@bree.surriel.com>
In-Reply-To: <20080207101634.4AC7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080130175439.1AFD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080206193512.77b5f21f@bree.surriel.com>
	<20080207101634.4AC7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 10:20:39 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> looks good.
> thank you clean up code.

Yeah, it looks good.

Too bad it still does not work :)

Oh well, I'll look at that tomorrow.  Jet lag is catching up
with me, so I should get some rest first...

-- 
All rights reversed.
