Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbXEMGWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbXEMGWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbXEMGWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:22:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56669 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbXEMGWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:22:00 -0400
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
From: David Woodhouse <dwmw2@infradead.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: "Maciej W. Rozycki" <macro-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>,
       kernel-discuss-CN5wO63fgwogsBAKwltoeQ@public.gmane.org,
       linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbou-JGs/UdohzUI@public.gmane.org>
In-Reply-To: <20070512230340.fef4b791.zaitcev@redhat.com>
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz>
	 <1178550653.11851.191.camel@pmac.infradead.org>
	 <20070507194949.GB3981@ucw.cz>
	 <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com>
	 <Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl>
	 <1178646751.2824.48.camel@pmac.infradead.org>
	 <20070512093509.f3d1865f.zaitcev@redhat.com>
	 <1179034789.2802.61.camel@shinybook.infradead.org>
	 <20070512230340.fef4b791.zaitcev@redhat.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 13 May 2007 14:21:56 +0800
Message-Id: <1179037316.2802.91.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 23:03 -0700, Pete Zaitcev wrote:
> I see your point, and it makes sense, but I'm not sure I agree completely.
> Maybe I'm traumatized by myterious rejects which happened to me before.
> Looking at the patch with vi showed absolutely no clue why it failed.

On the occasions that that happens to me, It's almost always due to
stripped whitespace. If it were charset-conversion, looking at the patch
should surely highlight the problem?

> BTW, here's one odd thing Gmane is doing:

Gmane didn't do that¹ -- Anton did. But it would apply just fine anyway;
Anton's error only causes a _cosmetic_ issue when viewing his mail, not
a problem with applying the patch.

The Content-Type: header only actually matters to git-am for the commit
comments.

-- 
dwmw2

¹ Although it did send me a batch of 'please confirm your mail'
  messages, which sucks a bit. It would be nice if it kept proper
  addresses in Cc.

