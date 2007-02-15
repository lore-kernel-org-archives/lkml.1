Return-Path: <linux-kernel-owner+w=401wt.eu-S932722AbXBONQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbXBONQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932723AbXBONQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:16:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38775 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722AbXBONQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:16:46 -0500
Subject: Re: irqdesc porting help
From: Arjan van de Ven <arjan@infradead.org>
To: Maximus <john.maximus@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
In-Reply-To: <3634de740702150511y52985c2ak21eb663961193f20@mail.gmail.com>
References: <3634de740702142231k938a4c5ic824c2eefc95c1b0@mail.gmail.com>
	 <20070215103347.GA18690@linux-sh.org>
	 <20070215104547.GA15772@flint.arm.linux.org.uk>
	 <3634de740702150511y52985c2ak21eb663961193f20@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 15 Feb 2007 14:16:38 +0100
Message-Id: <1171545398.12771.599.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 18:41 +0530, Maximus wrote:
> Hi,
>    My drivers in 2.6.14 use statements like
>              desc->triggered = 1;
>    And desc also points to some members of irqdesc which arent in
> 2.6.19 but in 2.6.14.
> 
>    Im a newbie, What changes am i supposed to make to make it work in 2.6.19.
>    Im not sure what changes are exactly needed.
> 


can you just post your driver so that the people here see what you are
actually doing ?


