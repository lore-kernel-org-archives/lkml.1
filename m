Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZHFFxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZHFFxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZHFFx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:53:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:35992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbZHFFx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:53:29 -0400
Message-ID: <4A7A6FAE.8020503@kernel.org>
Date: Thu, 06 Aug 2009 14:52:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Al Viro <viro@ftp.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 1/2] chrdev: implement __[un]register_chrdev()
References: <4A79283E.7030202@kernel.org> <20090805161643.GA28436@kroah.com> <4A79B3A6.7090109@kernel.org> <20090805164919.GA27457@kroah.com> <4A79BB04.8000408@kernel.org> <20090805171547.GB10443@kroah.com>
In-Reply-To: <20090805171547.GB10443@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 06 Aug 2009 05:53:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Greg KH wrote:
> Yes the names are confusing, the whole api needs a rework to make it
> easier to understand :(

For now, I'll open code it then but it would be really nice to clean
the names up.

Thanks.

-- 
tejun
