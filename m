Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbZIKWBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbZIKWBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZIKWBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:01:03 -0400
Received: from fifo99.com ([67.223.236.141]:60503 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbZIKWBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:01:02 -0400
Subject: Re: [PATCH] [16/21] HWPOISON: The high level memory error handler
 in the VM v7
From: Daniel Walker <dwalker@fifo99.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: npiggin@suse.de, riel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090911215745.GG32562@basil.fritz.box>
References: <20090911848.933193846@firstfloor.org>
	 <20090911184845.38A6EB1758@basil.firstfloor.org>
	 <1252697149.28368.12.camel@desktop>
	 <20090911193346.GE32562@basil.fritz.box>
	 <1252702684.28368.21.camel@desktop>
	 <20090911215745.GG32562@basil.fritz.box>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 15:01:31 -0700
Message-Id: <1252706491.28368.32.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 23:57 +0200, Andi Kleen wrote:
> On Fri, Sep 11, 2009 at 01:58:04PM -0700, Daniel Walker wrote:
> > On Fri, 2009-09-11 at 21:33 +0200, Andi Kleen wrote:
> > > > The rest of your patches are totally clean, except this one .. It has
> > > > some warning, but one error in the second ifdef block above ..
> > > 
> > > That's intentional, fixing it would require a bare , on a single line
> > > which would be far uglier what is there today. I refuse to make code
> > > ugly just to work around checkpatch.pl
> > 
> > 
> > Like the following is clean, and I don't see why it would work. Although
> > I only compile tested it.
> 
> That would turn a simple two liner change into a monstrosity of patch.

It's a dirty job, but someones got to do it..

Daniel

