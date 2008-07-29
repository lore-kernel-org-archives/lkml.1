Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbYG2EBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbYG2EBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbYG2EBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:01:47 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:28507 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750767AbYG2EBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:01:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=z6yIs1x6hTwpf0RCtoG+L7FTV0Xsbx8VOdbHwBAn0s+wwoIdWAqdgBbwspTMdPpF3AH2+jIRmGVh+IERz7SmFGU17kqZWZce2qheG+zlv57SH3fWZD3UoJ/gi1rXjip0U9i3UgLS95YNfqiuGHxtctWTfAWI8Juxpo8Zy/hlcAE=  ;
X-YMail-OSG: 1sYS7PYVM1mSVi1xMDRBtfr8cBk.rp0hJFpF54WaF4RB1Q2JoGYeU5LDOwTb8azM60d.ztqFNihum5ZHyMHWLJCgAzFkAa8dt.5m310R6JPFTJUVusmYXAn4JN9wCKLRCcQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux v2.6.27-rc1
Date: Tue, 29 Jul 2008 14:01:32 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291401.32255.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 13:23, Linus Torvalds wrote:

> Other stuff? tracing. firmware loading. continued x86 arch merging. And
> moving more code to generic support (unified generic IPI handling,
> coherent dma memory allocation, show_mem etc). bootmem rewrites. Some
> support for further scalability (ie 4k cpu cores).

And lockless pagecache, woohoo!
