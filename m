Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbZAVPa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbZAVPa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 10:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZAVPaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 10:30:15 -0500
Received: from khc.piap.pl ([195.187.100.11]:56082 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbZAVPaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:30:14 -0500
To: Miguel =?iso-8859-2?Q?=C1ngel_=C1lvarez?= 
	<gotzoncabanes@gmail.com>
Cc: Karl Hiramoto <karl@hiramoto.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: IXP4XX queues
References: <b0438a630901212342o543ed522p60376f764b6248b5@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 22 Jan 2009 16:30:10 +0100
In-Reply-To: <b0438a630901212342o543ed522p60376f764b6248b5@mail.gmail.com>
 ("Miguel =?iso-8859-2?Q?=C1ngel_=C1lvarez=22's?= message of "Thu\, 22 Jan
 2009 08\:42\:28 +0100")
Message-ID: <m3k58nicjh.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Ángel Álvarez <gotzoncabanes@gmail.com> writes:

> Last December we talked about 64 queues and IXP4XX. Karl has a patch
> for them, and although I think it could be better to splitt it into
> two different ones ("plain 64 queue expansion" for which I proposed a
> modified patch based on Karl's, and "debugging and other things"), I
> prefer Karl's to none.

I will look at this stuff again soon, currently -ENOTIME but this
condition will only last for few days. Thanks for the reminder.
-- 
Krzysztof Halasa
