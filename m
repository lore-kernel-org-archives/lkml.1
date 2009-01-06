Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZAFXSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZAFXSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZAFXSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:18:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbZAFXSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:18:30 -0500
Date: Tue, 6 Jan 2009 15:17:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Warren Turkal <wt@penguintechs.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Diego Elio 'Flameeyes' =?ISO-8859-1?Q?Pe?= =?ISO-8859-1?Q?tten=F2"
	 ?= <flameeyes@gmail.com>
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106151747.c640dfd4.akpm@linux-foundation.org>
In-Reply-To: <20090106225744.GA10553@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Tue, 6 Jan 2009 17:57:44 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> 
> > hfs-add-basic-export-support.patch
> 
> I'm pretty sure we already had a version better than that in your
> tree on the list.  But I've lost track and we should just restart
> the review cycle on -fsdevel.

Yeah, I have the three hfs patches:

hfsplus-identify-journal-info-block-in-volume-header.patch
hfsplus-fix-journal-detection.patch
hfs-add-basic-export-support.patch

in a holding pattern awaiting a second round, due to laggy, incomplete
and confusing noises from various people.  It all needs a revisit.

