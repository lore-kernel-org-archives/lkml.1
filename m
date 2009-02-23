Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZBWK2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZBWK2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZBWK2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:28:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:32894 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZBWK2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:28:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XdLwPfvlXSZATNm7KXnmTjpzhdWEry6k/mGF7lMLQWm2zkv8wLc5QKxEX8Ws4l/XSP
         eC8mngpo6o4H4ZOOzVaCdIgSeWDhrUcCjzx8bofOydDJqXemH8XHC9+zdgblj2FbRTbD
         rudVx1+Quf+fTNe4Ak1wOakMrUBLy9QlKJxtM=
MIME-Version: 1.0
In-Reply-To: <435196707.27641@eyou.net>
References: <1234944825-10299-1-git-send-email-crquan@gmail.com>
	 <435196707.27641@eyou.net>
Date: Mon, 23 Feb 2009 18:28:07 +0800
Message-ID: <91b13c310902230228g116836b0of85494934e39313f@mail.gmail.com>
Subject: Re: [PATCH] [KBUILD] add symbol value to help find the real depend
From: Cheng Renquan <crquan@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 2:12 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Hi,
>
> This looks good/helpful.  Can it be made to work with
> gconfig & xconfig as well as menuconfig?

Patches for gconfig & xconfig are already in progress, please be
patient, I will post later. Thanks,

-- 
Cheng Renquan, Shenzhen, China
Henny Youngman  - "When I told my doctor I couldn't afford an
operation, he offered to touch-up my X-rays."
