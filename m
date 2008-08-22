Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbYHVJTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbYHVJTC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 05:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYHVJSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 05:18:53 -0400
Received: from main.gmane.org ([80.91.229.2]:33369 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbYHVJSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 05:18:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Compiling the kernel with VMware
Date: Fri, 22 Aug 2008 10:18:34 +0100
Message-ID: <g8m09a$hee$1@ger.gmane.org>
References: <11887b820808212026v52c7c7adj175a774e5506f237@mail.gmail.com> <11887b820808212102y65e4b744q2da69dc3a9d03a30@mail.gmail.com> <1219383831.4021.247.camel@moss.renham>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 86.53.68.233
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette wrote:

> 
> On Thu, 2008-08-21 at 23:02 -0500, Alex Zajac wrote:
>> Hello,
>> Currently, I wanted to begin work on the kernel, and as such, I need a
>> way to compile it. All I have available to me is my XP Home computer
>> (and I lack funds to buy another, so please do not just say, "get a
>> Linux comp"). The specs are as follows:
>> 1.4 Ghz Single-core processor
>> 384 MB RAM
>> 20 GB hard drive (5.5 GB free right now)
>> 
>> Now, is there a way to compile the kernel using VMware Player? If so,
>> what image would be the best to boot and use? Also, exactly what would
>> I have to do to set up VMware and the image so that I could compile?

Don't.  It's much more useful having linux run on the bare metal - so you
can test real drivers etc.  Grab the Ubuntu Wubi installer, which allows
you to install Ubuntu linux "as just another application under windows"
(paraphrased).  It will live in a file on your windows filesystem; you will
have to reserve a set amount of space in advance.  Other than that it'll be
a classic dual-boot system.

Alan

