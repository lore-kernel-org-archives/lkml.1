Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYE0Sdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYE0Sdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbYE0SdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:33:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:34844 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974AbYE0SdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:33:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QmkLLsa4yhkHOI7supA7Gh7aOf9STTM23cFX+jwKuZv49Ruk+4DF3sNC7h/39WSYTp/zTPSWx7Vj7SgDvTvDphvDUJu7lPIL2XeF4YjKs94hFybZ7b6zDrCbP8wqOITA7iw0+GPeNgpVlz0h6oiSV0Z/R4TqrdXGyiIx6KdoY48=
Message-ID: <86802c440805271133h1f93b92fkef99f8effeaaf223@mail.gmail.com>
Date: Tue, 27 May 2008 11:33:17 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 28/28] firmware: convert korg1212 driver to use firmware loader exclusively
Cc: "David Woodhouse" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080525141113.57c48bd9@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211708969@pmac.infradead.org>
	 <E1K0DOQ-0007Ea-GW@shinybook.infradead.org>
	 <20080525141113.57c48bd9@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 6:11 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sun, 25 May 2008 11:23:58 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
>
>> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
>
> Acked-by: Alan Cox <alan@redhat.com> for the rest of the series too
> --

any chance to make it get into 2.6.26?

before this i need to keep two copies klibc with fw (qla24xxx) in
initramfs. one for 32 bit and one for 64 bit.

YH
