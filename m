Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbYJBB4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbYJBB4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYJBB4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:56:32 -0400
Received: from animx.eu.org ([216.98.75.249]:33952 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYJBB4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:56:32 -0400
X-Greylist: delayed 2237 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Oct 2008 21:56:31 EDT
Date: Wed, 1 Oct 2008 21:19:04 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: How to make all of 4GB of memory available?
Message-ID: <20081002011904.GA22197@animx.eu.org>
Mail-Followup-To: Robert Hancock <hancockr@shaw.ca>,
	Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
References: <fa.LzFGkHEK7iy88LF74OslLpTs7d0@ifi.uio.no> <48E41426.9060006@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E41426.9060006@shaw.ca>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Gene Heskett wrote:
> >New mobo, 4 core AMD Phenom cpu & 4 GB of dram.  I cannot find the switch 
> >in a make xconfig that will allow use of all of it, I am only seeing 3GB.
> >
> >Am I going blind in my dotage?
> >
> >Thanks.
> >
> 
> HIGHMEM64G. Or better yet, use a 64-bit kernel.

It may be a little odd, but I have a 64-bit x86 that I'm running 32-bit
kernel.  Mostly because I had some odd problems with various programs I was
using.  But was what more odd was the fact that I had a little less memory
(~100mb) with a 64-bit kernel than with a 32-bit PAE kernel.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
