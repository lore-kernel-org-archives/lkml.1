Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYKMDBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYKMDBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYKMDB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:01:28 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:34424 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYKMDB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:01:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=m3R33m7fYB2FR4HOMK/UA84xHgeOurtWeAr2aZNxdrp4vk90lr96vWyl3E5bHkor7v
         ScD5TuRSvf+7InyIq8cLKPRLjtXKxbCCCGgCN99uUTuD2XjVGc7L2c46RjDDp/rt9xhT
         sOAczY9lCcV6bhWLuOZ7OaK+1WhHmShU0qg3M=
Message-ID: <386072610811121901m3e81fyc0698fa6e662eaa7@mail.gmail.com>
Date: Thu, 13 Nov 2008 11:01:26 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/4] usb/musb Blackfin updates
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1226287515-27247-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226287515-27247-1-git-send-email-cooloney@kernel.org>
X-Google-Sender-Auth: 99d02dc9dd3046b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

Do you have time to review these patches and merge them to your queue?

Thanks
-Bryan

On Mon, Nov 10, 2008 at 11:25 AM, Bryan Wu <cooloney@kernel.org> wrote:
>
> Hi Felipe,
>
> I regenerated the "[PATCH 15/17] usb: musb: add Blackfin specific
> configuration to MUSB" on top of your patches. It should be easy for
> you to merge.
>
> And in this patchset, some other small fixings are included as well as.
>
> Thanks
> -Bryan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
