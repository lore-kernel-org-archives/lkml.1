Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYKQRNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYKQRNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYKQRNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:13:15 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:35274 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYKQRNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=szilHIcTFs5e2gcXoEfe8mr4k7z+bM3wRPYoAv8JKUQshfUfSPq0PSsTiYFjnsdyXX
         QdbMB9xU+M96zp0WTwqVop+RnIVy4RxD2UVKbWZhGj+CuaLLgU6Is6hxYsmVYk3Rpttw
         Jefq5vxhTTorlKnI5VblNvfwmsMrYXmv52VNo=
Message-ID: <3aaafc130811170913o761ce43fg3a2738586ebd2396@mail.gmail.com>
Date: Mon, 17 Nov 2008 12:13:11 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Inclusion of tp_smapi module into kernel?
Cc: "=?ISO-8859-1?Q?Hanno_B=F6ck?=" <hanno@hboeck.de>,
       linux-kernel@vger.kernel.org, tpctl-users@lists.sourceforge.net
In-Reply-To: <49219DF5.5040404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200811171455.50039.hanno@hboeck.de> <49219DF5.5040404@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 11:38 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Hanno Böck wrote:
>>
>> I wanted to ask if there is some status on possible kernel inclusion. On
>> http://www.linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
>> I read
>> "will not be accepted upstream due to authorship issues (written by an
>> anonymous developer)"
>>
>> Now I can see copyright notices in all source files, though they may be
>> incomplete. But anyway, would this be a real problem?
>> Is there any rule that kernel code needs a named author? As long as it has a
>> fitting license, shouldn't this be fine?
>>
>
> We need to be able to identify who owns the copyright.  For all we know,
> the anonymous submitter might not have the right to his own work (work
> for hire, etc.) or it could have been produced in violation of NDA
> terms, etc.

There are several utilities maintained by this author, and finding
some way to merge the code has been tried more than once. If you look
back far enough, Andrew asked to have another of the project's members
sign off on the patch, and maybe that would be acceptable enough, but
afaik the author has never responded directly to that idea.

>
>        -hpa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
