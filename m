Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZAIDVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZAIDVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 22:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZAIDVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 22:21:38 -0500
Received: from smtpauth23.prod.mesa1.secureserver.net ([64.202.165.47]:36993
	"HELO smtpauth23.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753254AbZAIDVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 22:21:37 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 22:21:37 EST
Message-ID: <4966C125.10604@duaneellis.com>
Date: Thu, 08 Jan 2009 22:14:45 -0500
From: Duane Ellis <duane@duaneellis.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: Florian Fainelli <florian@openwrt.org>,
       Thiago Galesi <thiagogalesi@gmail.com>,
       Hugo Villeneuve <hugo@hugovil.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: FPGA programming driver architecture
References: <20081212150314.6ea24996.hugo@hugovil.com>	 <82ecf08e0901081414u15af3c2dy9c88a242db024dc7@mail.gmail.com>	 <c384c5ea0901081447i5ad807b3yb0ec3adebeaa46a0@mail.gmail.com>	 <200901082357.24432.florian@openwrt.org> <c384c5ea0901081507v5d186eai5ec71d56b4c7a972@mail.gmail.com>
In-Reply-To: <c384c5ea0901081507v5d186eai5ec71d56b4c7a972@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >> [various FPGA config methods]

Don't forget JTAG, and playing back an SVF files, or BIT files.

-Duane.

