Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728Ab0ANO4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0ANO4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 09:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363Ab0ANO4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 09:56:50 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:59197 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0ANO4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 09:56:50 -0500
Date: Thu, 14 Jan 2010 08:56:38 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Fix mbind vma merge problem
In-Reply-To: <20100114154720.6732.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1001140854440.14164@router.home>
References: <20100114154720.6732.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cannot find any fault with this but then I am not too familiar with the
whole vma merging thing.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>


