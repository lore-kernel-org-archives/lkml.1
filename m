Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbXCIIrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbXCIIrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXCIIrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:47:11 -0500
Received: from mx01.bfk.de ([193.227.124.2]:39883 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbXCIIrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:47:10 -0500
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2007 03:47:10 EST
To: Niklaus <niklaus@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: more than 65535 outbound connections
References: <85e0e3140703090016h609ecc5t504121a99bcd3e44@mail.gmail.com>
	<85e0e3140703090019r7daf5ce4g9269925773374bf7@mail.gmail.com>
From: Florian Weimer <fweimer@bfk.de>
Date: Fri, 09 Mar 2007 09:36:47 +0100
In-Reply-To: <85e0e3140703090019r7daf5ce4g9269925773374bf7@mail.gmail.com> (niklaus@gmail.com's message of "Fri, 9 Mar 2007 13:49:34 +0530")
Message-ID: <82d53izucg.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> i read on the web that terry lambert has got 1.6 million simultaneous
> connection ? how is the way it is done.

Multiple IP addresses, I guess.

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
