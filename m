Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYFKM6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYFKM6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYFKM6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:58:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYFKM6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:58:08 -0400
Date: Wed, 11 Jun 2008 08:57:24 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: 2.6.26-rc5-mm2: OOM with 1G free swap
Message-ID: <20080611085724.1c18164f@bree.surriel.com>
In-Reply-To: <20080610232705.3aaf5c06.akpm@linux-foundation.org>
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
	<20080611060029.GA5011@martell.zuzino.mipt.ru>
	<20080610232705.3aaf5c06.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 23:27:05 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Well I assume that Rik ran LTP.  Perhaps a merge problem.

> Zero pages on active_anon and inactive_anon.  I suspect we lost those pages.

Known problem.  I fixed this one in the updates I sent you last night.

-- 
All rights reversed.
