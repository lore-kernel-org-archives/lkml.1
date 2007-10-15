Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbXJOJSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbXJOJSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbXJOJSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:18:41 -0400
Received: from ms.trustica.cz ([82.208.32.68]:40987 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbXJOJSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:18:40 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2007 05:18:39 EDT
Message-ID: <47132EE2.1050208@assembler.cz>
Date: Mon, 15 Oct 2007 11:12:02 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Icedove 1.5.0.12 (X11/20070731)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: "Mark M. Hoffman" <mhoffman@lightlink.com>, apiszcz@solarrain.com,
       lm-sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
       Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: [lm-sensors] 2.6.23.1 x86 hardware monitoring bug?
References: <Pine.LNX.4.64.0710141526590.3935@p34.internal.lan>	<20071015025331.GA3676@jupiter.solarsys.private> <Pine.LNX.4.64.0710150406220.9867@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0710150406220.9867@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Most likely you have distro and custom libsensors installed on the system. (and 
different PATH for root)

Please check how many of libsensors libraries is installed.

Thanks,

Rudolf
