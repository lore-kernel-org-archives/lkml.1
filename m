Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbYJAVJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbYJAVJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbYJAVIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:08:54 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42632 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYJAVIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:08:53 -0400
Subject: Re: How to make all of 4GB of memory available?
From: Kasper Sandberg <lkml@metanurb.dk>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810011417.00595.gene.heskett@gmail.com>
References: <200810011417.00595.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Wed, 01 Oct 2008 23:08:51 +0200
Message-Id: <1222895331.25858.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-01 at 14:17 -0400, Gene Heskett wrote:
> Greetings;
> 
> New mobo, 4 core AMD Phenom cpu & 4 GB of dram.  I cannot find the switch in a 
> make xconfig that will allow use of all of it, I am only seeing 3GB.
> 
> Am I going blind in my dotage?

Are you using 32bit? if so, are you use PAE?

> 
> Thanks.
> 

