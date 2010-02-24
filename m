Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab0BXWis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:38:48 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:63645 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408Ab0BXWiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:38:46 -0500
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 17:38:46 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gJUkONub0RFhZtZu4aHxQeE8xhATO9eE/fEbeGX1EksAcbWBCw+8dv0w8Rx9RE6wNv
         XsO5WDBrNBiz9xRFBshtLF/NGyDDtHw0RKtqKG1iqmVkV4kR9SG/p8X7M1LJbk4MBBsg
         UvYElnGIBfwFTvx28or4gaMDH39nN67oq4ehk=
MIME-Version: 1.0
In-Reply-To: <b170af451002210750i33221b3egc0bb940eac7191f5@mail.gmail.com>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
	 <4B814AB3.1030404@shipmail.org>
	 <b170af451002210750i33221b3egc0bb940eac7191f5@mail.gmail.com>
Date: Wed, 24 Feb 2010 23:33:15 +0100
Message-ID: <b170af451002241433n2875f552wb2a2170b7d4a2c23@mail.gmail.com>
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to sleep 
	(w. timeout) until wake_up
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Thomas Hellstrom <thomas@shipmail.org>, Dave Airlie <airlied@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

Can I interpret lack of objections as permission for committing that?

If so, by which tree should we get this patch mainline?

Dave: this patch is needed for radeon driver. Can we get this through
drm-2.6 maybe?

-- 
Rafał
