Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbXDDU57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbXDDU57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXDDU57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:57:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:26093 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbXDDU56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SoWigaUXaUeyf4OKyWrHO/gjBkc69IFKeYdeJNTd+O+Zw82pjowm9Egs2EZT3lvp85mCQyw4cd62oQuiR1+FdzPWAwvFT8/1cR4XESCtmL6xSVezHJ9T2XTZ2KMRraSiPfM6r72z4Eu/XMDjiGlu8y9kqe5yJ0OseAqmF0Mj94s=
Message-ID: <d120d5000704041357r1dd813c6k33676dfdc44b86c5@mail.gmail.com>
Date: Wed, 4 Apr 2007 16:57:57 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Tony Lindgren" <tony@atomide.com>
Subject: Re: [PATCH 11/90] ARM: OMAP: Add support for Amstrad Delta keypad
Cc: linux-kernel@vger.kernel.org, "Jonathan McDowell" <noodles@earth.li>
In-Reply-To: <1175709977545-git-send-email-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11757099691323-git-send-email-tony@atomide.com>
	 <11757099743984-git-send-email-tony@atomide.com>
	 <1175709977545-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/07, Tony Lindgren <tony@atomide.com> wrote:

> +       KEY(0, 7, KEY_LEFTSHIFT),       /* Vol up       */

KEY_VOLUMEUP?

> +       KEY(3, 7, KEY_LEFTCTRL),        /* Vol down  */

KEY_VOLUMEDOWN?

-- 
Dmitry
