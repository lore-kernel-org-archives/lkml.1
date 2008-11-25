Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYKYH1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYKYH1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYKYH1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:27:31 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:34344 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbYKYH1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:27:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uee4WDE/Yi9w+9v8dpM2Vc3JTHKz5ltrfngSrW+2oLttNoWhTAkXu3YE4l2NfJrp5d
         1l3ow98npsdkYuXJv5kVLdALJRIGuU5oRdTRh1hn2SHPV8tGOlGb2V5m97B2n9ZQsAoS
         Kew69ZHZuT9IfUDUohy774O/A7ryXwGdZIuGw=
Message-ID: <5d5443650811242327gc204050lf232dfac48ae4f1@mail.gmail.com>
Date: Tue, 25 Nov 2008 12:57:29 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: v4l2_device/v4l2_subdev: please review
Cc: v4l <video4linux-list@redhat.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200811250810.01767.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811242309.37489.hverkuil@xs4all.nl>
	 <5d5443650811242251g5ddda028q9413b0ff47fc08a8@mail.gmail.com>
	 <200811250810.01767.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

>
> I'm not going to spam the list with these quite big patches. Just go to
> http://linuxtv.org/hg/~hverkuil/v4l-dvb-ng/ and click on the 'raw' link
> after each change to see the patch. Most of these changes are just
> boring i2c driver conversions.

It is hard to review these patches from this link, as if you submit
the patch to ML then someone can just give inline comments to your
patch, otherwise reviewer has to copy that code which he/she wants to
comment while replying and not easy to track too. I don't know size
limit of this v4l2 ML, but linux-kernel ML can receive somewhat big
patches I believe.

>
> We are adding to the v4l core, but the changes do not affect existing
> v4l drivers let alone other subsystems. Although I should probably have
> added the omap list.

OMAP + soc-camera + v4l2-int-* community would be more interested to
see these patches as they need to change their sensor/controller
drivers to adapt your changes.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
