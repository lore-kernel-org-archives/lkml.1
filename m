Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZJRWRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZJRWRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZJRWRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:17:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:15368 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbZJRWRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dK1AO4+Nj9MnGyeBKSNfQlMkwkmj7BRtKmr4s42zd+csV/00/zO7OpjXCmx/5m6aKO
         aXx2BlrfdkAeDicyPWUTUBzER52HpzY7T/KRMtnHQrrU5yVelVkYIZ0xfh4RR5o5EM9a
         Tx6OKB/nMYsDwoF/+EWSjwf0DlmfE8q/AdGg0=
MIME-Version: 1.0
In-Reply-To: <94a0d4530910081346j57b155a1o10e4a4545e7548b3@mail.gmail.com>
References: <94a0d4530910061157q7b682750r3279bca4716cd532@mail.gmail.com>
	 <Pine.LNX.4.44L0.0910061604160.3002-100000@iolanthe.rowland.org>
	 <94a0d4530910081346j57b155a1o10e4a4545e7548b3@mail.gmail.com>
Date: Mon, 19 Oct 2009 01:17:54 +0300
Message-ID: <94a0d4530910181517vc3a0766la727d7c97d7792b5@mail.gmail.com>
Subject: Re: Annoying problems with lacie external hd (JMicron 0x2339?)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 8, 2009 at 11:46 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Tue, Oct 6, 2009 at 11:10 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> A usbmon trace would contain more information.  We could see the exact
>> sequence of commands and error codes.  I'm not sure it would help solve
>> anything, though.
>
> I followed the tutorial and the resulting log is 73M long. I don't
> know what I'm looking for, so there it is:
> http://people.freedesktop.org/~felipec/1.mon.out

Can you take a look? Is there anything else I can provide?

-- 
Felipe Contreras
