Return-Path: <linux-kernel-owner+w=401wt.eu-S1761691AbYBBEnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691AbYBBEnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 23:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYBBEmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 23:42:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:48380 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbYBBEmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 23:42:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=T7dmnIAm6L+GU2KVUe3fUBTXUBdFHZp5FjwsswvrtUXPhArPixfPi5cYBXmSTMNTmwj9sZhTT08sjrx7i++5X19QN9H5NpRbfMUJYVZTnWSgsY4qe/LM4pvXi5FLXV+apht0k+d93SjqnZbrDARlTPtbvr7jwRQyQBe7C8L6vWw=
Message-ID: <47A3F4C7.4060406@googlemail.com>
Date: Sat, 02 Feb 2008 05:42:47 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Daniel Hazelton <dhazelton@enter.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Various Errors with recent GIT
References: <200802012252.29454.dhazelton@enter.net>
In-Reply-To: <200802012252.29454.dhazelton@enter.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton wrote:

> 
> Another problem is one I wasn't able to find any kind of trigger for, other 
> than just running XChat. Every so often XChat would seem to freeze - but if 
> run from the command line, switching to that terminal window and 
> hitting "ctrl-c" would cause it to rapidly update and become responsive again. 
> The freeze would happen at a random time interval that I couldn't figure out.
> 

I got that Xchat problem on i686 yesterday. 

I'm running 2.6.24-06481-gaa62999 right now with near 4h uptime and the problem seems fixed.

> DRH
> 

Gabriel
