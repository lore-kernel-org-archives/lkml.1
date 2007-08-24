Return-Path: <linux-kernel-owner+w=401wt.eu-S1764728AbXHXN6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764728AbXHXN6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 09:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXHXN6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:58:14 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60334 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956AbXHXN6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:58:13 -0400
Date: Fri, 24 Aug 2007 09:58:12 -0400
To: TheOneKEA <theonekea@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possible problems reading a DVD-RAM disc
Message-ID: <20070824135812.GH9412@csclub.uwaterloo.ca>
References: <443c85430708231944s102dff82u366a93824f7c2222@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <443c85430708231944s102dff82u366a93824f7c2222@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 10:44:55PM -0400, TheOneKEA wrote:
> While doing a long mega-copy from one side of a DVD-RAM disc formatted
> with the vfat filesystem to an smbfs network share, I got lots and
> lots of these in the dmesg:

No idea about the error, but isn't vfat torture of a dvd-ram?  Don't
they come preformated with UDF since it does wear leveling while vfat
would very very quickly trash the part of the disk storing the FAT.

--
Len Sorensen
