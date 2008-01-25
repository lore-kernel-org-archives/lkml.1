Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbYAYW3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbYAYW3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYAYW3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:29:46 -0500
Received: from 1wt.eu ([62.212.114.60]:1612 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYAYW3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:29:45 -0500
Date: Fri, 25 Jan 2008 22:56:39 +0100
From: Willy Tarreau <w@1wt.eu>
To: David Newall <davidn@davidnewall.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Patches for linux-2.4
Message-ID: <20080125215638.GK8953@1wt.eu>
References: <479A36D3.5010608@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479A36D3.5010608@davidnewall.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sat, Jan 26, 2008 at 05:51:55AM +1030, David Newall wrote:
> What's the process for submitting patches for a linux-2.4 driver?  I'm
> sure this is a FAQ, but I can't find the answer.

Simply post them to the list with subjects beginning with "[PATCH] 2.4: "
so that we notice them. Please CC me because I can easily miss them as
they now represent about 1/2000 of the mails here!

Also, you should ensure that your patches are really relevant to the
usage people have of 2.4 nowadays. If you fix bugs, that's fine. If
you want to contribute new drivers/features, you should first check
that they are correctly working in 2.6 so that people do not get
trapped when they migrate from 2.4 to 2.6, and you should also ensure
that those patches are not only posted for your own convenience ;-)

With all that in mind, please do post your patches, I'm open for
reviewing and discussing them.

Thanks,
Willy

