Return-Path: <linux-kernel-owner+w=401wt.eu-S1761061AbYGRWN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061AbYGRWN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759952AbYGRWLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:11:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:23938 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759872AbYGRWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-authentication-warning:to:cc:subject:references:from:in-reply-to
         :message-id:lines:user-agent:mime-version:content-type:date;
        b=InDLGy1O3KbE/aziysR4GpHRtqdYUXChHrRKWfMI9RRwSWObfzsY6dYH/OgfowGtUD
         WhRLVXOpSYWD8ZSg+DJAgs1/DX9wH3pBt+9Di4N5yS7SDl0WIwmlNsm6q3rJDHynBxb1
         YFiPZYW4Quhf7YYTAySFuXy3yMY7s42jZNouw=
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, git@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: gitdm v0.10 available
References: <20080718154657.7ff0cf9e@bike.lwn.net>
From: Jakub Narebski <jnareb@gmail.com>
In-Reply-To: <20080718154657.7ff0cf9e@bike.lwn.net>
Message-ID: <m31w1qyha8.fsf@localhost.localdomain>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 18 Jul 2008 15:11:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> writes:

> Gitdm (the "git data miner") is the tool that Greg KH and I have used
> to crank out statistics on where kernel patches come from.  For the
> curious, I have (finally) put up a public repository for gitdm at:
> 
> 	git://git.lwn.net/gitdm.git

I have added information about this tool to Git Wiki:
  http://git.or.cz/gitwiki/InterfacesFrontendsAndTools#head-fbb1cec362b54c74c5bbad3766f8a8f8f883af12

Please check if it is correct, and correct any mistakes (it is wiki!).
-- 
Jakub Narebski
Poland
ShadeHawk on #git
