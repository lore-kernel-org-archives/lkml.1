Return-Path: <linux-kernel-owner+w=401wt.eu-S966137AbXHaSHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966137AbXHaSHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 14:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXHaSHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 14:07:39 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:15402 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965672AbXHaSHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 14:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OhryB+3Lr5jvvRwtpWsPWY2BSsepIo8VGvOhlWwyqdO80zs9Tk8x7uCc+15xXnEdbIbGjaDDLCTWMyhIVjl1fwXsBt/h555QyfOM/zzBObtnlG7qSmkBDFY0Gag+ocZ/LSIOU2qRf9MsB0uZpWKP1HdisSOENRTp53b8p6sV+Dk=
Message-ID: <6bffcb0e0708311107vaa93e9ekdee55f28b6ca9cdb@mail.gmail.com>
Date: Fri, 31 Aug 2007 20:07:37 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [ANNOUNCE] DeskOpt - on fly task, i/o scheduler optimization
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070831103943.5e44ad4f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D8354A.3030208@googlemail.com>
	 <20070831103943.5e44ad4f@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/2007, Arjan van de Ven <arjan@infradead.org> wrote:
> On Fri, 31 Aug 2007 17:35:38 +0200
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > Hi,
> >
> > Here is something that might be useful for gamers and audio/video
> > editors http://www.stardust.webpages.pl/files/tools/deskopt/
> >
>
>
> question is how many of the things they changed can we just make
> default...
>

Good question.

If we want to change the default settings, we need to carefully
benchmark all changes - it is not simple, because some things work
different on desktop/server/embedded.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
