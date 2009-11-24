Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbZKXG02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbZKXG02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbZKXG02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:26:28 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:58548 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756091AbZKXG01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:26:27 -0500
X-Greylist: delayed 1911 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 01:26:27 EST
Date: Tue, 24 Nov 2009 16:54:38 +1100
From: CaT <cat@zip.com.au>
To: Reg Clemens <reg@dwf.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel options.
Message-ID: <20091124055438.GA3639@zip.com.au>
References: <200911240456.nAO4uAlB002080@deneb.dwf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911240456.nAO4uAlB002080@deneb.dwf.com>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 09:56:10PM -0700, Reg Clemens wrote:
> I have a pre-compiled 64bit kernel from Fedora11, and I can execute
> both 32 and 64bit executables with it.
> 
> I have just built a new kernel (to test some PPS code), and I CANT
> execute 32bit executables with it.
> 
> There must be some option I didnt check.
> What is it?????

In the Executable formats menu there is an option (IA32 Emulation) to run
32bit binaries in 64bit land.

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
