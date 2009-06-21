Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZFULkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZFULkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZFULk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:40:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:55305 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZFULk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:40:29 -0400
Subject: Re: [PATCH -tip] x86: mm/hugetlbpage.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rohit Seth <rohitseth@google.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090621112201.GA13435@elte.hu>
References: <1245582881.3052.3.camel@localhost.localdomain>
	 <20090621112201.GA13435@elte.hu>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 17:09:55 +0530
Message-Id: <1245584395.3052.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 13:22 +0200, Ingo Molnar wrote:

> this change is not an improvement either.
> 
> Plus at a first glance that file has a couple of other problems as 
> well beyond trivial style issue:
> 
>  - dead code which should be removed
> 
>  - a 64-bit only boot option that should probably be extended to 
>    32-bit as well
> 
>  - insanely long function names with local scope, causing ugly 
>    linebreaks
> 
> and more style issues as well:
> 
>  - various inconsistent capitalizations in comment blocks
> 
>  - some other small details as well
> 
> Lets try to do a genuinely big and comprehensive forward step that 
> addresses all these issues (and any other issues that are in that 
> file), ok?
> 

ok, I will try.

--
JSR

