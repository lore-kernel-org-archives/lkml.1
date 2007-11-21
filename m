Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbXKUK6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbXKUK6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbXKUK6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:58:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:15930 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbXKUK6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:58:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iyXGjhtt6WhKArJxNGxXYyH24Nu7Y50P4w74Hva7hN1djwLzbZhWdNEw8/FSR4NnoxZ+Todya3X7XzLVuVBqmoRreFygL8KbgZ/iqtRQlD6YEXEikS6V6TJ20gDcK9tCY/VE8Kh416I2mQI4YXhvgC3/FvPtlzd6Itplqn7o50E=
Message-ID: <aa79d98a0711210258t3e6f5532oe710c04b93b06c8@mail.gmail.com>
Date: Wed, 21 Nov 2007 13:58:06 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [PATCH] PPC: trivial fix of missed increment on counter
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Kumar Gala" <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <aa79d98a0711210056n6cc951atf4c6af5be26c1ed0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aa79d98a0711210056n6cc951atf4c6af5be26c1ed0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> This patch does fix missed increment on counter
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> Sorry for that nonstandart patch submission - I've only access
> to gmail with Internet Explorer on my work. If that is not OK - will resend
> the patch today evening with mutt.
>
>
Oops - it seems the patch is corrupted a bit. Drop it please - will
resend today evening. Sorry.

Cyrill
