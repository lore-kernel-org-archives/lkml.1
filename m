Return-Path: <linux-kernel-owner+w=401wt.eu-S946433AbXHMOLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946433AbXHMOLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965118AbXHMLMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:12:36 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:22271 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S944124AbXHMLMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:12:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YykbWEPMaQPiQ1mPwOX2R/kuhgX0lTueRGmcVKHVQ414wPgJ3jjaEHW9GvS+dpjZWoY9GDxlZ24vRRh5BjY8gF+hnmLYzFl+B8Mplcg/TeABMpGzXJKD6lUiJuBRB/ohmkLNeC6mjb9ygy5RTdE617UQQx5tBS+geTV8z2v1OZo=
Message-ID: <4727185d0708130412k1d427b82k4a401d22c7d72c2a@mail.gmail.com>
Date: Mon, 13 Aug 2007 13:12:33 +0200
From: "Vincent Legoll" <vincent.legoll@gmail.com>
To: "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] - Add "def_bool" Kconfig format documentation
Cc: zippel@linux-m68k.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070811220928.b079d2e5.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186439380.21014.9.camel@quad>
	 <20070811220928.b079d2e5.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/07, Randy Dunlap <rdunlap@xenotime.net> wrote:
> There are also def_boolean and def_tristate.
> I suppose that I should resubmit this patch:
>   http://marc.info/?l=linux-kernel&m=115471883121076&w=2

This one is OK for me, you can add:
Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>

-- 
Vincent Legoll
