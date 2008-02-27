Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYB0FfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYB0FfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 00:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYB0FfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 00:35:14 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:12655 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYB0FfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 00:35:12 -0500
Date: Tue, 26 Feb 2008 21:34:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "SL Baur" <steve@xemacs.org>
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, ricknu-0@student.ltu.se,
       bhalevy.lists@gmail.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: multiple updates
Message-Id: <20080226213432.1388717b.randy.dunlap@oracle.com>
In-Reply-To: <ed10ee420802261657w3830e1a1rf0cc9601cdacb142@mail.gmail.com>
References: <1204062430.47c488def40a4@portal.student.luth.se>
	<20080226135444.f83a0536.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0802270033310.5714@axis700.grange>
	<m31w6zcm4l.fsf@maximus.localdomain>
	<ed10ee420802261657w3830e1a1rf0cc9601cdacb142@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 16:57:47 -0800 SL Baur wrote:

> On 2/26/08, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> 
> >  Hopefully an elisp expert will implement it. Vim people probably need
> >  something like that as well, and the list of editors is a bit longer...
> 
> The proposed two space change is ugly.  Can someone NAK it?
> 
> -sb (The elisp guy who added the linux c-style)

I would gladly NAK it, but most recent email from Linus about
coding style is that we are getting too detailed about it,
so unless there is some overwhelming need to change anything in
CodingStyle, I'm for no changes (or maybe even some removals).

---
~Randy
