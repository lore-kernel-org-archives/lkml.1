Return-Path: <linux-kernel-owner+w=401wt.eu-S965296AbXA3M3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965296AbXA3M3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 07:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965295AbXA3M3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 07:29:09 -0500
Received: from ns1.suse.de ([195.135.220.2]:56516 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965296AbXA3M3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 07:29:08 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: via irq quirk breakage
Date: Tue, 30 Jan 2007 13:29:03 +0100
User-Agent: KMail/1.9.1
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
References: <45B6A94A.3010006@yahoo.com.au> <200701291600.32580.jdelvare@suse.de> <20070129155125.74758322@localhost.localdomain>
In-Reply-To: <20070129155125.74758322@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701301329.03334.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

Le Lundi 29 Janvier 2007 16:51, Alan a écrit :
> This is a lot neater than the original patch too. Only problem I see is
> pci=reverse might need more care.

What do you mean exactly? I thought pci=reverse had been dropped years ago?

-- 
Jean Delvare
Suse L3
