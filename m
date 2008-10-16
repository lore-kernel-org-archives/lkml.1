Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYJPTj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYJPTj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYJPTjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:39:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbYJPTjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:39:21 -0400
Message-ID: <48F79856.30609@linux-foundation.org>
Date: Thu, 16 Oct 2008 14:39:02 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: Re: [PATCH 2/5] mm: don't vmalloc a huge page_to_node array for do_pages_stat()
References: <48F3AD47.1050301@inria.fr> <48F3ADD4.60307@inria.fr>
In-Reply-To: <48F3ADD4.60307@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Lameter <cl@linux-foundation.org>

