Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbYHGOGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbYHGOGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYHGOGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 10:06:41 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:21873 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYHGOGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:06:40 -0400
Subject: Re: Btrfs v0.16 released
From: Chris Mason <chris.mason@oracle.com>
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <3da3b5b40808070703x4cf49471q6acc00351ba019d7@mail.gmail.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <3da3b5b40808070703x4cf49471q6acc00351ba019d7@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 10:06:20 -0400
Message-Id: <1218117980.15342.200.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 17:03 +0300, Ahmed Kamal wrote:
> With csum errors, do we get warnings in logs ?

Yes

>  Does too many faults cause a device to be flagged as faulty ?

Not yet

>  is there any user-space application to monitor/scrub/re-silver btrfs
> volumes ?
> 
Not yet, but there definitely will be.

-chris


