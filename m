Return-Path: <linux-kernel-owner+w=401wt.eu-S1161065AbXBOTlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161065AbXBOTlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161067AbXBOTlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:41:18 -0500
Received: from lazybastard.de ([212.112.238.170]:40802 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161065AbXBOTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:41:18 -0500
Date: Thu, 15 Feb 2007 19:36:58 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: v j <vj.linux@gmail.com>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070215193657.GA24643@lazybastard.org>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <1171524970.12771.568.camel@laptopd505.fenrus.org> <9b3a62ab0702150004n78763d4ei652b41c7edcd0755@mail.gmail.com> <45D416FF.4030302@student.ltu.se> <9b3a62ab0702150040i593d4f25p4beb7fcd1a81f9a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b3a62ab0702150040i593d4f25p4beb7fcd1a81f9a8@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 February 2007 00:40:31 -0800, v j wrote:
> 
> Oh, I am sorry. Seems like the German courts have spoken. I am not
> sure about what, but they have spoken. Sorry for the confusion.

In short, there seem to be two classes of closed-source drivers:

1. ATI and nVidia.  Both are well-known, in both cases they seem to
avoid the legally important aspect of shipping their driver along with a
kernel and they seem to be legally in relatively safe water.  At least I
haven't heard about them getting sued yet.

2. The embedded companies.  By the very nature of selling an embedded
device they are shipping their drivers along with a kernel and seem to
be in very shallow water.  Dozens of them have received letters from
lawyers and didn't even dare go to court - they just complied.

While this list is not exhaustive and your company's case may be
different from all others, it does give you a hint of what your chances
might be in court.  Go to http://gpl-violations.org/ and do your
research.

The question whether a specific closed-source driver is legal or not can
only be answered in court and only on a case-by-case basis.  You should
have a good idea of what many developers personal opinion is and with
the research you can also estimate your legal position.  Then make your
decision, as noone here is going to make it for you - even if some would
like to.

Jörn

-- 
Eighty percent of success is showing up.
-- Woody Allen
