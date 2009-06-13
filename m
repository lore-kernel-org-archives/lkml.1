Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZFMRts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZFMRts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 13:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755311AbZFMRtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 13:49:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38864 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbZFMRtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 13:49:40 -0400
Message-ID: <4A33E6B1.1040203@zytor.com>
Date: Sat, 13 Jun 2009 10:49:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: the right time to run my super-duper, kernel cleanup scripts?
References: <alpine.LFD.2.00.0906130907070.4074@localhost>
In-Reply-To: <alpine.LFD.2.00.0906130907070.4074@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   i figure it's almost time to annoy the crap out of everyone again by
> running my standard source "cleanup" scripts to track down things
> like, well, this:
> 
> http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup
> 
>   i'm thinking that the right time is after the chaos of the merge
> window is mostly over so ... once rc1 is out?  is that about the right
> time to give any fixes a chance to settle?
> 

Yes, run that stuff on -rc1 and then notify people to fix it.

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

