Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbXFRIjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbXFRIjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbXFRIjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:39:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:64435 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343AbXFRIjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TER6tvKKBYzYdxxf16SDkeOft4QRWeTlMdRqB/EDWjSe7zEKqzp1+fjK+Y4ITQ8UTjTnREHl9P+q4T0b4dBFtCrmWeYslxnHdyn83tfs3xm8QkL/Tg4ffKYLAvIL66d5jU1PfWq6Byh3XN62GFVxnsJjECWMLRLa6tam7/Hmeg8=
Message-ID: <467644AE.5050008@gmail.com>
Date: Mon, 18 Jun 2007 10:39:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] make pci_ids lowercase hexa
References: <116342983010020429@wsc.cz> <20070616195738.GB23443@kroah.com> <4674DDEF.8090600@gmail.com> <20070617214555.GA305@kroah.com>
In-Reply-To: <20070617214555.GA305@kroah.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH napsal(a):
> On Sun, Jun 17, 2007 at 09:08:31AM +0200, Jiri Slaby wrote:
>> Greg KH napsal(a):
>>> Why?  What good is this going to do in the long run?
>> It's just cleanup to get rid of things like this:
>>  #define PCI_DEVICE_ID_PROMISE_20246	0x4d33
>>  #define PCI_DEVICE_ID_PROMISE_20262	0x4d38
>> -#define PCI_DEVICE_ID_PROMISE_20263	0x0D38
>> +#define PCI_DEVICE_ID_PROMISE_20263	0x0d38
>>  #define PCI_DEVICE_ID_PROMISE_20268	0x4d68
> 
> Get rid of what?  What's wrong with upper case hex numbers?  This seems
> like a pretty gratitous change to me.

Ok.

> Care to resend your other fixes to me, if you still think they are
> needed?

Sure.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
