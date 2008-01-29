Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYA2WmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYA2WmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYA2Wls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:41:48 -0500
Received: from web32409.mail.mud.yahoo.com ([68.142.207.202]:40193 "HELO
	web32409.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752360AbYA2Wlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:41:47 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 17:41:47 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=P+uY6I0EaXa8SUixj/v4eYnbLAF4dGgOob4u3vmoC81wvzJ1JBSqbbkl6j//nOYPBpJrsdEbzkXgPYaTJsehOLeH25LI683FEycJ2I9f2MOPzWZWnvxvIvQH+r+5MRZ6Oyx7Fl8HKuBh0eAAn7zp7wgy2EQ80xzLFlqUYhA6jq8=;
X-YMail-OSG: XYMqluIVM1nkZD5M7aGtzShEK6g3aw6TNWHP9reIm89LG9zCR_r1_TZTlv_0WMz0DQniRTMQQzBAGooiVDWglGOY1esTf3x13orHuK5yqcneqSZRFTT6Lv_7kQ--
Date: Tue, 29 Jan 2008 14:35:07 -0800 (PST)
From: Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
To: Valdis.Kletnieks@vt.edu, Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
In-Reply-To: <24944.1201645637@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <682467.73095.qm@web32409.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Valdis.Kletnieks@vt.edu wrote:

> At some point, a compromise position of "Have ndiswrapper do the tainting
> if it loads something with contentious licensing" was suggested - whatever
> happened to that?
> 
> (If for no other reason than if you load ndiswrapper for testing, and then
> do *not* actually load something, your kernel should remain untainted...)

ndiswrapper does taint the kernel when a Windows driver is loaded.

Giri


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

