Return-Path: <linux-kernel-owner+w=401wt.eu-S936231AbYEBTwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936231AbYEBTwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935953AbYEBTwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:52:36 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:35541 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935739AbYEBTwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:52:35 -0400
Message-ID: <481B70F9.6000201@krogh.cc>
Date: Fri, 02 May 2008 21:52:25 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc>	 <20080501223938.921f7cd2.akpm@linux-foundation.org>	 <481ACEC4.2040205@krogh.cc> <481B3115.30705@krogh.cc> <2c0942db0805020847q2fdc0480m3eb892bf2bd0b3a@mail.gmail.com>
In-Reply-To: <2c0942db0805020847q2fdc0480m3eb892bf2bd0b3a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> BTW, I may have missed this earlier, but does it happen *anywhere* on
> the troublesome filesystem (ie, in a newly created subdirectory)?

Yes. It is reproducible on a newly created subdirectory on the
filesystem.

Jesper
-- 
Jesper
