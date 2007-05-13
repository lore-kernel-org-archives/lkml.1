Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbXEMGu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbXEMGu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbXEMGuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:50:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37040 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbXEMGuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:50:19 -0400
Subject: Re: linux-2.6.21-gitN - versioning question
From: David Woodhouse <dwmw2@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       YOSHIFUJI Hideaki /
	 =?UTF-8?Q?=E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E?= 
	<yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070513064325.GA8244@cvg>
References: <Pine.LNX.4.61.0705121316540.9570@yvahk01.tjqt.qr>
	 <20070512.210308.93070730.yoshfuji@linux-ipv6.org>
	 <20070512131906.GF8337@cvg>
	 <1178977496.2802.5.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0705121701020.9570@yvahk01.tjqt.qr>
	 <1179037601.2802.96.camel@shinybook.infradead.org>
	 <20070513064325.GA8244@cvg>
Content-Type: text/plain
Date: Sun, 13 May 2007 14:50:10 +0800
Message-Id: <1179039012.2802.117.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 10:43 +0400, Cyrill Gorcunov wrote:
> Btw David who does release a such snapshots (like git16)? You or
> Linus? 

I do. Not that I've actually had much involvement with it for a while --
it's mostly done by cron and the script at
http://david.woodhou.se/git-snapshot.sh

-- 
dwmw2

