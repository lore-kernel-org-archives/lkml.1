Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZKBG1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZKBG1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 01:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZKBG1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 01:27:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37655
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbZKBG1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 01:27:31 -0500
Date: Sun, 01 Nov 2009 22:27:55 -0800 (PST)
Message-Id: <20091101.222755.200487074.davem@davemloft.net>
To: icculus@icculus.org
Cc: alan@lxorguk.ukuu.org.uk, mans@mansr.com, linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.OSX.1.10.0911012023020.55434@caridad.local>
References: <alpine.OSX.1.10.0911011540400.53392@caridad.local>
	<20091102000147.424f104b@lxorguk.ukuu.org.uk>
	<alpine.OSX.1.10.0911012023020.55434@caridad.local>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ryan C. Gordon" <icculus@icculus.org>
Date: Sun, 1 Nov 2009 21:21:47 -0500 (EST)

> That being said, there are lots of places where using a package 
> manager doesn't make sense:

Yeah like maybe, just maybe, in an embedded system where increasing
space costs like FatELF does makes even less sense.

I think Alan's arguments against FatELF were the most comprehensive
and detailed, and I haven't seem them refuted very well, if at all.
