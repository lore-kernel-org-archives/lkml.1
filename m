Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbXLGXVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbXLGXVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXLGXU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:20:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:25121 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbXLGXU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:20:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ep8kxd60duXvdMjceVj1xo7LLQzAd9R5e1A/WFoHdjMv/tUJVEmM11gsVOsUKlytgDpiXQRiTIn8ZrAaGputhFpHs4yefe/cFKlFQAZkQ7CoLjT41H/UcRAy+mSZaDmTHuK77w0Huy0T/n4sbT7tVwaUUI7SaFMQ+SHLrILFmYo=
Message-ID: <4759D54F.1080304@gmail.com>
Date: Sat, 08 Dec 2007 08:20:47 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: question about sata-error on boot.
References: <200711021934.21123.volker.armin.hemmann@tu-clausthal.de> <20071106221556.55c3cd0b.akpm@linux-foundation.org> <200712071432.08699.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200712071432.08699.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hemmann, Volker Armin wrote:
> this is gone with 2.6.22.13 an 2.6.23.9:

Thanks for letting us know.  Probably CLO related problem which got
updated recently.

-- 
tejun
