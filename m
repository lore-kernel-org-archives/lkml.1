Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbYIXTiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbYIXTiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYIXTiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:38:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25621 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYIXTiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:38:14 -0400
Date: Wed, 24 Sep 2008 12:36:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/3] corruption check: move the corruption checks into
 their own file
Message-Id: <20080924123644.0fc343f6.randy.dunlap@oracle.com>
In-Reply-To: <20080924101608.5c99612e@infradead.org>
References: <20080923215335.05678239@infradead.org>
	<20080923225306.09fc27b4.akpm@linux-foundation.org>
	<20080924101608.5c99612e@infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008 10:16:08 -0700 Arjan van de Ven wrote:

> On Tue, 23 Sep 2008 22:53:06 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> 
> > __init?
> 
> I got flamed already for changing code while it's just being moved ....

You mean what Ingo said?  I don't see any flames in what he said.
Maybe you got flames by private email??

> I'll look at your cleanup suggestions as another separate patch
> please ;(

whatever.

---
~Randy
