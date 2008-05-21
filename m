Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbYEUGVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbYEUGVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbYEUGVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:21:42 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56084 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758034AbYEUGVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:21:42 -0400
Date: Wed, 21 May 2008 10:20:46 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080521062043.GB27362@2ka.mipt.ru>
References: <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com> <20080519054554.GY103491721@sgi.com> <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com> <20080520002503.GC173056135@sgi.com> <20080520065622.GA13968@2ka.mipt.ru> <20080520214617.GU103491721@sgi.com> <20080520222505.GA23988@2ka.mipt.ru> <20080520232256.GA16105@2ka.mipt.ru> <20080520233015.GY103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520233015.GY103491721@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 09:30:15AM +1000, David Chinner (dgc@sgi.com) wrote:
> Which is the exact implementation of
> 
> 	filemap_fdatawrite_range(mapping, start, end);

Cool, I did not know that, probably because it is not exported :)

-- 
	Evgeniy Polyakov
