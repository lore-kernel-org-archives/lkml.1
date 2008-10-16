Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYJPJKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYJPJKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYJPJKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:10:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYJPJKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:10:00 -0400
Message-ID: <48F704E6.2010409@zytor.com>
Date: Thu, 16 Oct 2008 02:09:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: el es <el_es_cr@yahoo.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com> <loom.20081016T075618-911@post.gmane.org>
In-Reply-To: <loom.20081016T075618-911@post.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

el es wrote:
> 
> the scheme to be s.yy.ww.tt, that is :
> 
> s - series, as it is now (freedom to Linus to declare a whole 'new generation'
> 
> ;) if he wanted  )
> 
> yy - two (in a hundred years, three) digits of the year
> 
> Now the interesting part begins which is
> 
> ww - the number of the week of the release. This will be between 1 and 52 (53)
> 
> tt - the number of the week of stable release. As above.
> 
> It is:
> - most similar to the scheme used so far,
> - informative : the ww and tt numbers are the week numbers of when the actual
> 
> release HAPPENED, not when it is predicted.
> 

Which really sucks for dealing with future releases.

	-hpa
