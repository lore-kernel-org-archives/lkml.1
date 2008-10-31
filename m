Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbYJaL4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbYJaL4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYJaL4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:56:02 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:32790 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYJaL4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FJQDwxIltsOEsf3j6AX4aKqfo/o81+ZqikXDR/ZaQs743iM0i67BFeR0ZGMW5iVK6B
         lzc5jVgeR/Wrxpppdk9WF/MdRtcNpGmx8O4N5/VUcTMQ9UaNdakCMsuqLxKQRQqJ4mom
         jvcOFUeYlswZWkob1Xo+gR86AxKRkH4iYh7DA=
Message-ID: <4104961b0810310455p2f5b7bdbvb58cca569a88e6c6@mail.gmail.com>
Date: Fri, 31 Oct 2008 19:55:59 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: "=?ISO-8859-1?Q?Am=E9rico_Wang?=" <xiyou.wangcong@gmail.com>,
       albcamus@gmail.com, ptesarik@suse.cz
Subject: Re: Where is asm-ia64 directory in 2.6.27 kernel?
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081031115324.GB3235@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <4104961b0810310445v49e13b85xe85d417bfe9ad979@mail.gmail.com>
	 <20081031115324.GB3235@hack.voiplan.pt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alright, I see, thank you all for quick response.

Regards
Jason

On Fri, Oct 31, 2008 at 7:53 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, Oct 31, 2008 at 07:45:02PM +0800, jidong xiao wrote:
>>Hi,
>>
>>I just noticed there is no such a directory now, where are the
>>including files re-located?Is it also merged into asm-x86??
>>
>
> $ ls arch/ia64/include/
> asm
>
>
> --
> "Sometimes the only way to stay sane is to go a little crazy."
>
>
