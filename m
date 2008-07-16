Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbYGPQhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbYGPQhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758806AbYGPQgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:36:54 -0400
Received: from mail.lang.hm ([64.81.33.126]:45695 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758637AbYGPQgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:36:53 -0400
Date: Wed, 16 Jul 2008 09:38:04 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cheradenine Zakalwe <sc.contact@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: The state of linux security
In-Reply-To: <67b4e5f30807160905n224a7808tf346dd4d506edd25@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0807160928150.17859@asgard.lang.hm>
References: <67b4e5f30807160905n224a7808tf346dd4d506edd25@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008, Cheradenine Zakalwe wrote:

> If it turns out that the current development model has produced too
> many security problems then the development model must change. I'd
> like to think that the integrity of most peoples systems is more
> important than some micro benchmark improvement because of some
> complex scheduler change.  That's not to say the latter isn't
> important, just that more time and effort needs to be put into making
> sure that the changes don't affect users in potentially disasterous
> ways.

how can you tell for sure if a bug has security implications or not?

the argument can be made that just about any bug can be a security bug

frequently the security implications of a bug are not known at the time 
it's fixed, but are discovered later. how do you expect to have this in 
the announcements?

if you only upgrade when there is a 'security bug' announcement you will 
miss a lot of important upgrades.

as Linus stated, there's nothing preventing anyone who thinks that he's 
not doing an appropriate job from doing the research on the security 
implications of everything and doing their own announcements or just 
maintaining their own tree.

David Lang
