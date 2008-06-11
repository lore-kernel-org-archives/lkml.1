Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYFKX4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYFKX4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 19:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYFKXz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 19:55:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYFKXz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 19:55:58 -0400
Message-ID: <48506602.4080500@zytor.com>
Date: Wed, 11 Jun 2008 16:55:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Keith Roberts <keith@karsites.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problems with edd
References: <311993399@web.de> <484F10A9.4030606@zytor.com> <alpine.LFD.1.10.0806112102350.18067@www.karsites.net> <485031FA.6070303@zytor.com> <alpine.LFD.1.10.0806120029040.23296@www.karsites.net>
In-Reply-To: <alpine.LFD.1.10.0806120029040.23296@www.karsites.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Roberts wrote:
> 
> The Fedora guys are following this thread now. I have put the link to 
> your patch on my Fedora bug report:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=450678
> 
> I have never built an iso file before, but I'll read up on it. My plan 
> was to copy the files from the F9 net-installer CD to my hard drive, 
> update them with your patch, and then re-make the iso file and burn that 
> back to CD-R. Would that work?
> 

Yes, that should work, assuming the iso file is generated with the same 
mkisofs options as the original image.

	-hpa
