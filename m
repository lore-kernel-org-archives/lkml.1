Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0CGN5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 08:57:33 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:65521 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0CGN5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 08:57:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xnS8mIxR14k+BFasOPvpvU+X2eVWP1bglL4KC7kYEawtIWFHO33Enc+Uk/6BHGBUer
         1ngQieHHMK0sBMOxQqOySBIh2FxREXD+A6R5txXqtSp1xul2S9pw+sjiVfYbf2A+3RU5
         6CbdZxoZ7Lm0AqyzSrtc6Y/LmEXERCfl2C04w=
MIME-Version: 1.0
In-Reply-To: <20100303094947.GB15480@sepie.suse.cz>
References: <1267545472-17131-1-git-send-email-jkacur@redhat.com>
	 <20100303094947.GB15480@sepie.suse.cz>
Date: Sun, 7 Mar 2010 14:57:29 +0100
X-Google-Sender-Auth: 56cd90a7b50cb102
Message-ID: <520f0cf11003070557m1eed4545yc990d7ed29277c46@mail.gmail.com>
Subject: Re: [PATCH] kbuild - tags
From: John Kacur <jkacur@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 10:49 AM, Michal Marek <mmarek@suse.cz> wrote:
> On Tue, Mar 02, 2010 at 04:57:52PM +0100, John Kacur wrote:
>>       - Add the ability to make tags for all archs using "all"
>>               make ALLSOURCE_ARCHS=all tags
>>       - Document this in kbuild.txt
>>
>>       Without this change you have to type each arch separately.
>>
>> Signed-off-by: John Kacur <jkacur@redhat.com>
>
> Thanks, applied.
>

Great! Are you going to send a pull request to Linus soon for 2.6.34?

Thanks
John
