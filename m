Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXIEKZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXIEKZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 06:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbXIEKZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 06:25:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36414 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbXIEKZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 06:25:29 -0400
Date: Wed, 5 Sep 2007 12:25:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stefan Becker <Stefan.Becker@nokia.com>
Cc: linux-kernel@vger.kernel.org, ext Andi Kleen <andi@firstfloor.org>
Subject: Re: [pre-2.6.23 REGRESSION] 2.6.23-rc3-git1 crash/stuck on VIA CN700 system
Message-ID: <20070905102525.GB31880@one.firstfloor.org>
References: <46C9D148.5080505@nokia.com> <p734pibbbex.fsf@bingen.suse.de> <46DDA366.8090806@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DDA366.8090806@nokia.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >Please report for mainline kernels.
> 
> I compiled a vanilla 2.6.23-rc5 kernel. Same problem. Still no sensible 
> debug information though...

Thanks. If you can easily reproduce it would it be possible to 
do a git bisect to track down which change caused it? 
See http://kerneltrap.org/node/11753 on how to do that.

-Andi
