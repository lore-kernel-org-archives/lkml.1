Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbXKJUzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbXKJUzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbXKJUzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:55:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:46896 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbXKJUzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:55:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dBRQuWhVl2feIMFPbIFyVkQ34Yu71gkmTQ3En3X+GOXflZ/PoiKHXaBjqrqLQwar75DCcxUG+hkvmoEthFIJaYt5RxWInlEa7mrrHaYLQl5DIUnvShDrl9aENEgornwCuf3CFuwbcvGxMq41NwB1IDLT0sY9geDm5wjvonFtclg=
Message-ID: <3d8471ca0711101255m1647e27cm241f358cc49a9921@mail.gmail.com>
Date: Sat, 10 Nov 2007 21:55:06 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <11947274091127-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071110204038.GA13140@uranus.ravnborg.org>
	 <11947274093185-git-send-email-sam@ravnborg.org>
	 <11947274091127-git-send-email-sam@ravnborg.org>
X-Google-Sender-Auth: 0a21f7f39eba385d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/10/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> The variable K64BIT can now be used to select the
> value of CONFIG_64BIT.

Why not calling the environment variable CONFIG_64BIT,
in preparation of the day when all CONFIG_ variables can
be passed by environment variables?

-- 
Guillaume
