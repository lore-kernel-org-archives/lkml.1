Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYFEHrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYFEHrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 03:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYFEHrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 03:47:33 -0400
Received: from tribbles2.addix.net ([212.51.16.14]:58968 "EHLO
	tribbles2.addix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYFEHrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 03:47:32 -0400
X-Greylist: delayed 1708 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 03:47:32 EDT
Message-ID: <4847935D.2070201@cruise.de>
Date: Thu, 05 Jun 2008 09:18:53 +0200
From: Uwe Klein <uwe.klein@cruise.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040114
X-Accept-Language: en-us, en
MIME-Version: 1.0
CC: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
References: <48447615.5050806@am.sony.com>	<20080604103353.GC27335@cs181133002.pp.htv.fi>	<4846E44A.1010601@am.sony.com>	<20080604191522.GA18873@uranus.ravnborg.org>	<4846EBAE.2000604@am.sony.com> <20080604202314.GG4189@cs181133002.pp.htv.fi>
In-Reply-To: <20080604202314.GG4189@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-ADDIX-Mailscanner-Information: Bitte wenden Sie sich an uns, falls Sie mehr Informationen haben moechten.
X-ADDIX-Scan: Virenfrei
X-ADDIX-From: uwe.klein@cruise.de
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:

 > I'm coming more from the point that drivers/media/ might be the area
 > in the kernel that currently offers the biggest flexibility - and this
 > stuff breaks multiple times for each kernel release, and sorting this
 > out is often nontrivial.

Only partially connected:
I have run into trouble in conjunction with the rtai patches
and the no_console option regularly over a couple of years.

compiling is ok linking breaks on afair on ?*pcspeaker*?
and some other symbols. reported it as a bug with rtai.

Due to time constraints I reactivated the console and moved on.

Imho  TINY setup and RT patches go together on a regular basis.
so some breakage goes beyond the kernel.

uwe

-- 
Uwe Klein [mailto:uwe.klein@cruise.de]
KLEIN MESSGERAETE Habertwedt 1
D-24376 Groedersby b. Kappeln, GERMANY
phone: +49 4642 920 123 FAX: +49 4642 920 125
