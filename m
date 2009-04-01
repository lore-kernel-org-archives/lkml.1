Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZDAKBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZDAKBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZDAKA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:00:59 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:40341 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbZDAKA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U1u0wuq0LtP4lmDkzaT5uy1VNpT7JkdhzMr4a+cruRdID73wWJP4BGQNxaZqegQ/C+
         8M/G3XUGC15Hl7r8OW5PcnNJQIs9v/3WJdngnYavPaiwy0BGGVgpBUOnOxOyCrJpIqBV
         2PqhuL2HB57X3nhGC3JNvKgxiRRm5rYWzLP88=
MIME-Version: 1.0
Date: Wed, 1 Apr 2009 13:00:53 +0300
Message-ID: <dac45060904010300y7fe8a09dxb582929fc8018ec1@mail.gmail.com>
Subject: sysfs tagged directory support status (was:. Re: [PATCH 1/8] sysfs: 
	Implement sysfs tagged directory support)
From: Mark Ryden <markryde@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Benjamin Thery <benjamin.thery@bull.net>,
       David Shwatrz <dshwatrz@gmail.com>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  I am back to it and I just want to ask if there are any news with
sysfs tagged directory support patch. Is it merged now ?
Regards,
Mark

On Tue, Oct 7, 2008 at 7:48 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Oct 07, 2008 at 06:39:04PM +0200, Mark Ryden wrote:
>> Hello,
>>   So I wonder: the sysfs tagged directory support patch is in GerKH
>> tree for more than a month.
>
> I dropped it from my tree 2 days ago, see the thread on lkml for why.
>
> thanks,
>
> greg k-h
>
