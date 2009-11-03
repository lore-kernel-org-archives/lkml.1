Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZKCPe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZKCPe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZKCPe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:34:57 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:44532 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZKCPez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:34:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wzunwDC5sV6EzTmoLBpmzDbUO7G+GcNGLsLL4L3r49mVhWS71XRCgQK0LdzuPA1/Ln
         Cj+CJzxCVIQUgVzSLRKJ4N+MQpJTJgAwQY39xBdfczYbZE31YLzm6sozjRDJ1UtOZBq2
         0ogj3xHAG0CICuOmqXaLVkNQTbmxsze7Z7II4=
Message-ID: <4AF04D9C.1050600@tuffmail.co.uk>
Date: Tue, 03 Nov 2009 15:34:52 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: Tim Abbott <tabbott@ksplice.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: Add generic binary search function to the kernel.
References: <1253626718-18887-5-git-send-email-alan-jenkins@tuffmail.co.uk>	 <1253726926-5504-2-git-send-email-tabbott@ksplice.com>	 <200909240941.41479.rusty@rustcorp.com.au>	 <alpine.DEB.1.10.0909271303580.14151@dr-wily.mit.edu> <a4c8a6d00911030714w2e885066g9af086818a968b7b@mail.gmail.com>
In-Reply-To: <a4c8a6d00911030714w2e885066g9af086818a968b7b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thiago Farina wrote:
> Hi, this patch was landed? It seems not to be in the tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6).
>   

I guess I'm sitting on it at the moment, having folded it into a patch 
series which I have yet to submit.

There are apparently already a number of implementations scattered 
around the kernel tree.  Perhaps you can add another copy of this 
implementation, wherever it is you need it :-).

Alan
