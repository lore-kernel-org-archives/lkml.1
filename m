Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbXEKFxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbXEKFxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 01:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbXEKFxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 01:53:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:24993 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbXEKFxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 01:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=VXu8zR8+YaWc/82QFGfQ6JbJo8451684SF/UpfzeIv2QM0jwPEQ2qRxVQAKGhjZWNjaDFKaE60ml2KehQF+e+wUHETuo+IfCQjoUB68IicW4XmaX/0D8PONPzmScHmDEdWUhyx5yzXHCSLq8LmSvbOfzSdBJTcHnYITKQbUD0+A=
Date: Fri, 11 May 2007 09:52:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070511055245.GA8324@cvg>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510154640.c0299a52.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Thu, May 10, 2007 at 03:46:40PM -0700]

[...snip...] 

| But please let's not add three copies of identical code.  Do something like:

[...snip...]

Thanks for comments, Andrew. Let me rewrite the patch...

		Cyrill

