Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbYIBKMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbYIBKMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 06:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYIBKMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 06:12:24 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:61269 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbYIBKMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 06:12:23 -0400
Message-ID: <48BD117A.1080103@nttdata.co.jp>
Date: Tue, 02 Sep 2008 19:12:10 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.16) Gecko/20080708 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: (repost) Confirmation of methods for calculating requested	pathname.
References: <48AA49DE.6000006@nttdata.co.jp> <48BCC1B6.5030901@nttdata.co.jp> <20080902050601.GA4149@x200.localdomain>
In-Reply-To: <20080902050601.GA4149@x200.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Sep 2008 10:12:14.0964 (UTC) FILETIME=[5F6A2B40:01C90CE4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know what Al Viro will say, but this is incredibly ugly.
> Even more ugly than previous patches.
Which approach did you mean by the "previous patches"?

* introduce security_path_* (new LSM hooks)
http://marc.info/?l=linux-security-module&m=120962139014606&w=2

* pass struct path * to vfs helper functions and existing LSM hooks
http://lkml.org/lkml/2008/5/29/217

Regards,

