Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbYB1ALW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbYB1ALW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbYB1ALJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:11:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:46732 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068AbYB1ALH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:11:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FsO+GWJTyisB/UnMo9ifl4S8Ot2OagG6SEsgwqH9R2Wh+E/4gi5+jGf/MHNi+Cqr25Z9mM4o/ET3fMoIp5ifCxiIo2qEMKoDAhAAJOwkFavuWwHe521tF8cDTgcIVQMenDeL36H1dfdK+FyvMe8px1saaOXc00JOu6s3S/h+GZA=
Message-ID: <ed10ee420802271611l3a09e76ej531158f167512a03@mail.gmail.com>
Date: Wed, 27 Feb 2008 16:11:06 -0800
From: "SL Baur" <steve@xemacs.org>
To: "Richard Knutsson" <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] CodingStyle: multiple updates
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, bhalevy.lists@gmail.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47C5DDE0.3040403@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204062430.47c488def40a4@portal.student.luth.se>
	 <20080226135444.f83a0536.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0802270033310.5714@axis700.grange>
	 <m31w6zcm4l.fsf@maximus.localdomain>
	 <ed10ee420802261657w3830e1a1rf0cc9601cdacb142@mail.gmail.com>
	 <20080226213432.1388717b.randy.dunlap@oracle.com>
	 <47C5DDE0.3040403@student.ltu.se>
X-Google-Sender-Auth: b85c3ea5970ab5d0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/08, Richard Knutsson <ricknu-0@student.ltu.se> wrote:

>  Actually, I see this as an quite simple question: is tab _the
>  indention-marker_? If not, then why the refusal of spaces indents (or mix)?

Because mixing spaces and tabs is often ugly.  8 spaces and a
single tab often do not have the same width when you're viewing
the text in a variable width font.

I've read all my mail in a variable width font for over a decade, at
first to watch for regressions in the XEmacs display engine, but I
continued because I liked it.  I presume I'm not the only one doing
so.

-sb
