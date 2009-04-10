Return-Path: <linux-kernel-owner+w=401wt.eu-S938607AbZDJQ5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938607AbZDJQ5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936983AbZDJQ5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:57:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43053 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761411AbZDJQ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WaSavnJNRZ39HLRgCKWk7eZIIWV7mJg/Txfgce/q2jn3V8w6ACHvj5lf98Kfxq9Zg3
         ml/CkOAJHneIBYvkIFM2hWQAQ2FhS7EoVq7t3yHoFbU+0XEy8oXzoBr71vdoZBkrdhz/
         s+Uqy95OYg8L/j5umQuxic3XWBXlCjiqSlDVo=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904101819070.21577@localhost.localdomain>
References: <8db1092f0904070037q426fd8dcx4aa48c70e40b5d6c@mail.gmail.com>
	 <20090409212028.7b2aa88c.akpm@linux-foundation.org>
	 <8db1092f0904100340g7b7eb310y805e8680a32e3ac8@mail.gmail.com>
	 <alpine.LFD.2.00.0904101329170.21577@localhost.localdomain>
	 <8db1092f0904100747w297a0daas9ebd05486d06e706@mail.gmail.com>
	 <alpine.LFD.2.00.0904101819070.21577@localhost.localdomain>
Date: Fri, 10 Apr 2009 18:57:02 +0200
Message-ID: <8db1092f0904100957v26083888hd326411d4ca801ce@mail.gmail.com>
Subject: Re: [2.6.29-git12] BUG: scheduling while atomic: swapper/0/0x10000100
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Forgot CC)

2009/4/10 Thomas Gleixner <tglx@linutronix.de>:

>
> Is this with my patch applied ?

Yes. I didn't observe any change.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
