Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbYCEETQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbYCEETQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 23:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYCEES7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 23:18:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbYCEES6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 23:18:58 -0500
Date: Tue, 4 Mar 2008 23:18:44 -0500
From: Rik van Riel <riel@redhat.com>
To: minchan Kim <minchan.kim@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 16/20] non-reclaimable mlocked pages
Message-ID: <20080304231844.499b5a03@bree.surriel.com>
In-Reply-To: <47CDE925.9090503@gmail.com>
References: <20080304225157.573336066@redhat.com>
	<20080304225227.780021971@redhat.com>
	<47CDE925.9090503@gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2008 09:28:21 +0900
minchan Kim <minchan.kim@gmail.com> wrote:

> Hi, Rik.
> 
> There is a some trivial mistake.
> It can cause compile error.

Thank you.  I have applied your fix.

-- 
All rights reversed.
