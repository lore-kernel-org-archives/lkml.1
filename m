Return-Path: <linux-kernel-owner+w=401wt.eu-S932360AbZJINvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbZJINvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760785AbZJINvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:51:47 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:37455 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753748AbZJINvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:51:46 -0400
Date: Fri, 9 Oct 2009 09:44:47 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Fix memory leak of do_mbind()
In-Reply-To: <20091009100837.128A.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0910090943130.26484@gentwo.org>
References: <20091009100527.1284.A69D9226@jp.fujitsu.com> <20091009100837.128A.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, KOSAKI Motohiro wrote:

> If migrate_prep is failed, new variable is leaked.
> This patch fixes it.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

