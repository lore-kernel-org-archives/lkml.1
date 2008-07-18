Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbYGRMlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbYGRMlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYGRMlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:41:40 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:42241 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886AbYGRMlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IWm+VTXhgI9JHraAgKNZrvvt5BhSJU1/+pPvp7d4R+DTjxy7YnEoEC4W05nE7XtRJU
         yQOLsS8Iex9NMExXXRRmdZ0TWbsd1YvrfYxuYHgTPOrvN7PM2Zv675Jk1YPslWNUkxd7
         Eshqxz2Lwd2802YkoU/oitXhQXRFpTllExgJA=
Message-ID: <48808F79.7080607@gmail.com>
Date: Fri, 18 Jul 2008 21:41:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support
 for device classes.
References: <m1vdzmh2jr.fsf_-_@frodo.ebiederm.org> <m1r6aah2hh.fsf_-_@frodo.ebiederm.org> <m1mykyh2fu.fsf_-_@frodo.ebiederm.org> <m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> <486DD650.3000804@gmail.com> <m1tzf593ny.fsf@frodo.ebiederm.org> <486E2C3B.6020603@gmail.com> <20080704161200.GA1440@suse.de> <m1lk052ptp.fsf@frodo.ebiederm.org> <487D6A24.9070001@gmail.com> <20080717230857.GB28377@suse.de>
In-Reply-To: <20080717230857.GB28377@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Ok, I'll work to get these in where applicable.

Did this get into 2.6.27?  Or will this have to wait till .28?

Thanks.

-- 
tejun
