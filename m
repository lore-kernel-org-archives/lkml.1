Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbZJINqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbZJINqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760785AbZJINqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:46:37 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:43293 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757536AbZJINqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:46:36 -0400
Date: Fri, 9 Oct 2009 09:39:31 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] mm: move inc_zone_page_state(NR_ISOLATED) to just
 isolated place
In-Reply-To: <20091009100527.1284.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0910090939060.26484@gentwo.org>
References: <20091009100527.1284.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

