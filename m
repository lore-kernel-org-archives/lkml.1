Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888Ab0AWPf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab0AWPf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 10:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725Ab0AWPf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 10:35:28 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:52916 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab0AWPf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 10:35:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=fz+UIEot3OkaiWaRMDd6cgzStBQfhPksd2xQYI+qAWODe2VHwXanHD4wQQ+MjEFnN7
         rOwpy539d6TJwNYSh52tk5f68syzSNUNMdvGeJYJUxmzcom598VhF4CGqeHTM3f8k2dj
         TKaKgOZnAGI7lT6UmrEm3gTef+5btjJ48CKe8=
Date: Sat, 23 Jan 2010 23:37:31 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Dimitry Golubovsky <golubovsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Current status of UML development?
Message-ID: <20100123153731.GA2759@hack>
References: <bcba51a1001211227y1cbe9020k5079367f05dd17a1@mail.gmail.com> <20100122162356.GA4771@hack> <20100122171145.GA13074@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100122171145.GA13074@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 12:11:45PM -0500, Jeff Dike wrote:
>On Sat, Jan 23, 2010 at 12:23:56AM +0800, Américo Wang wrote:
>> On Thu, Jan 21, 2010 at 03:27:58PM -0500, Dimitry Golubovsky wrote:
>> >I am learning/experimenting with UML internals, and am curious what is
>> >the current status of its development? Has UML become stable enough so
>> >it does not need any improvement (at least for i386), or has its
>> >development just ceased in favor of other virtualization techniques?
>> >
>> 
>> Of course not.
>
>This is being generous.  I haven't really done any work on UML in the
>last year or so, although bugs are found and patches contributed (by
>Américo, among others).
>

Oh, seems you are busy. If you want I can take UML patches for you.
But of course, I need kind help from you and others.

Thanks.
