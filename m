Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbYEFRvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbYEFRvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYEFRvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:51:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50427 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756137AbYEFRvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:51:11 -0400
Date: Tue, 6 May 2008 10:51:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/page_alloc.c: fix a typo
In-Reply-To: <482029E7.6070308@cn.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0805061050110.23336@schroedinger.engr.sgi.com>
References: <4820272C.4060009@cn.fujitsu.com> <482027E4.6030300@cn.fujitsu.com>
 <482029E7.6070308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Li Zefan wrote:

> Sorry for the noise, but the signed-off was eaten. :(
> Maybe I should leave a blank line before the signed-off.

I think the | there was some developers attempt to avoid gcc generating 
too many branches. I am fine either way.

