Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbZCQVvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbZCQVvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbZCQVvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:51:38 -0400
Received: from CPE-124-189-51-38.nsw.bigpond.net.au ([124.189.51.38]:53867
	"EHLO bunyip.billabong.weebeastie.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752722AbZCQVvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:51:37 -0400
Date: Wed, 18 Mar 2009 08:51:28 +1100
From: CaT <cat@zip.com.au>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, dtor@mail.ru, corentincj@iksaif.net
Subject: Re: 2.6.29-rc8: boot/kernel init duration regression from 2.6.28
Message-ID: <20090317215128.GK32025@zip.com.au>
References: <20090316102521.GJ32025@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316102521.GJ32025@zip.com.au>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 09:25:21PM +1100, CaT wrote:
> I have a Eee and just decided to try rc8 with the result that kernel
> init now takes around 20s longer than it did under 2.6.28. From dmesg
> it takes place here:

Did a few compiles yesterday (they take ages due to the number of files
touched by the patches) and so far this can be repeated with rc2 (as well
as rc4, rc8 and rc8-git2).

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
