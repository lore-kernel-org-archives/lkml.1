Return-Path: <linux-kernel-owner+w=401wt.eu-S934198AbZIDURG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbZIDURG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934171AbZIDUQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:16:55 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:60767 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934072AbZIDUQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:16:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RlnllfAqzYO/BtRpJWIgvGTA+ch+psbJutLHl0EjHMxGt8bRrUxKS7r4iPOVpu4XoK
         gfxTtPLrjPHNVm3ytXmVklPQfzangzn4wSgyDvR5BtukcqibL/ZoEwaSno/WBGtSse3X
         XXV3MY/+rIoGIp3/9YwTVV73Ixy8+HF82Uo98=
MIME-Version: 1.0
In-Reply-To: <1252089313.5254.0.camel@dhcp231-106.rdu.redhat.com>
References: <8db1092f0909020629v5aab79d8lbfcc8c214622787c@mail.gmail.com>
	 <200909030907.02321.oliver@neukum.org>
	 <20090903160536.GA24050@kroah.com>
	 <200909041223.22835.oliver@neukum.org>
	 <8db1092f0909040710t5c048e93j3fb5adc9e7f1cf6a@mail.gmail.com>
	 <8db1092f0909041130p2733f7ebs5ee8211c48bab861@mail.gmail.com>
	 <1252089313.5254.0.camel@dhcp231-106.rdu.redhat.com>
Date: Fri, 4 Sep 2009 22:16:43 +0200
Message-ID: <8db1092f0909041316l77da5d75n1934d340db26e6ec@mail.gmail.com>
Subject: Re: [2.6.31-rc8] Problem with detect USB devices
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org, ebiederm@aristanetworks.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/4 Eric Paris <eparis@redhat.com>:

>
> Update to Linus's newest git tree.  It has a fix for this problem.
> Sorry for all the trouble.

Yes, upgrade to latest git tree solves problem. Thanks.


Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
