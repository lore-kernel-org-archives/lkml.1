Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbZKPJsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbZKPJsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 04:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZKPJsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 04:48:03 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:48206 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752233AbZKPJsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 04:48:02 -0500
Date: Mon, 16 Nov 2009 09:48:03 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: "Feng, Xiaobing" <Xiaobing.Feng@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       linux-pci@vger.kernel.org, giancarlo.asnaghi@st.com,
       "Wallin, Anders" <Anders.Wallin@windriver.com>,
       "D'Agostino, Raffaele" <raffaele.dagostino@windriver.com>,
       "Li, Li" <Li.Li@windriver.com>,
       "Tang, ChunQiang" <ChunQiang.Tang@windriver.com>
Subject: Re: [PATCH 2/2] Uart driver for ST Microelectronics
 ConneXt(STA2X11/STA2X10).
Message-ID: <20091116094801.GJ20341@fluff.org.uk>
References: <52CF90264091A14888078A031D780F436EF0F9@ism-mail03.corp.ad.wrs.com>
 <52CF90264091A14888078A031D780F4302F89338@ism-mail03.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CF90264091A14888078A031D780F4302F89338@ism-mail03.corp.ad.wrs.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why not register an AMBA device and use the extant AMBA PL011 driver?

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
