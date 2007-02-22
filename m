Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbXBVVz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbXBVVz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXBVVz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:55:27 -0500
Received: from terminus.zytor.com ([192.83.249.54]:52183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbXBVVz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:55:26 -0500
Message-ID: <45DE113D.1020606@zytor.com>
Date: Thu, 22 Feb 2007 13:55:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: webmaster@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: gitweb on kernel.org buggy?
References: <Pine.LNX.4.64.0702222219520.10496@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0702222219520.10496@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> Hi,
> 
> the gitweb running on git(2).kernel.org has looked buggy to me for quite a 
> some time (a month or so) with respect to branches vs. shortlog.
> 
> When you browse a repository with mutliple branches, and switch between 
> branches, the shortlog shown is always the one from master, never from the 
> branch you switched to, which seems wrong to me.
> 
> This definitely worked previously (and works on other installations of 
> gitweb outside the kernel.org), so it might be worth fixing.
> 
> Thanks,
> 

gitweb on kernel.org is at least in part orphanned, since the "official" 
gitweb maintainers don't seem to listen to us (kernel.org people) w.r.t. 
some issues, mainly related to caching, we've had to fork gitweb and 
maintain it ourselves -- however, since kernel.org is currently all 
volunteer labor, we have limited amount of time in which to deal with 
things.

	-hpa
