Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbZB0Puu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbZB0Puu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbZB0Pul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 10:50:41 -0500
Received: from norkia.v3.sk ([92.240.234.41]:44798 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646AbZB0Pul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 10:50:41 -0500
Subject: Re: Failover Kernel
From: Lubomir Rintel <lkundrak@v3.sk>
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <49A80796.2070208@turknet.net.tr>
References: <49A659D0.2040903@turknet.net.tr>
	 <200902261802.56612.diegocg@gmail.com>  <49A80796.2070208@turknet.net.tr>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 16:50:50 +0100
Message-Id: <1235749850.4718.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-02-27 at 17:32 +0200, Tarkan Erimer wrote:
> Diego Calleja wrote:
> > Isn't this what kdump does right now? http://lwn.net/Articles/108595/
> >   
> 
> Yep, very similar to "kdump". But, kdump is too simple. Backup kernel is 
> just so minimal and only to handle crash dump thing. With "Failover 
> kernel", I'm talking about fully functional backup kernel like primary 
> one. Not just too minimally functioning crash dump kernel.

How is the backup kernel minimal? It is usually the very same kernel as
the "primary" one. You can use the same initrd as well and do a full
multiuser boot.

-- 
Lubomir Rintel <lkundrak@v3.sk>

