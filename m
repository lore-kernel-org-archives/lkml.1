Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYIKMp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYIKMp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 08:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYIKMpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 08:45:16 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62658 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYIKMpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 08:45:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hGQ6lv2l001AOr5XoRx4OBnfJKPD1tLcXweIN5UDg60Y8rQOnKzYGTELb86NhayExs
         C5ucpRYCDM/HjlcaGNSur5nnFujIEGuJ+ybLaTo/akOT8FbTxIrXHHJBR8del2cWGNPf
         7eUdq8itegJt8zg5qrDujA3WWlS5BS88oMXwQ=
Message-ID: <48C912CF.7080000@gmail.com>
Date: Thu, 11 Sep 2008 14:45:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <gregkh@suse.de>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support
 for device classes.
References: <m1mykyh2fu.fsf_-_@frodo.ebiederm.org> <m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> <486DD650.3000804@gmail.com> <m1tzf593ny.fsf@frodo.ebiederm.org> <486E2C3B.6020603@gmail.com> <20080704161200.GA1440@suse.de> <m1lk052ptp.fsf@frodo.ebiederm.org> <487D6A24.9070 <m1zlnu60uc.fsf@frodo.ebiederm.org>
In-Reply-To: <m1zlnu60uc.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any progress here? Nothing seems reached lkml...

Eric W. Biederman napsal(a):
> Greg KH <gregkh@suse.de> writes:
> 
>> I'll add it to my tree, and get it some testing in the next cycle of
>> linux-next until 2.6.27 is out, and then if it's still looking good, go
>> into .28.
> 
> Greg.  Where are we at with this?
> 
> I just looked at your tree and I don't perhaps I'm blind but I don't see
> this patches, and it looks like you at least refreshed your patches
> a day or two ago.
