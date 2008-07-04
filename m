Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYGDIu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYGDIu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 04:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYGDIuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 04:50:20 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:17198 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbYGDIuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 04:50:19 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-8.tower-164.messagelabs.com!1215161418!13400274!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Fri, 4 Jul 2008 10:50:14 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>
Subject: Re: alphabetic ordering of MAINTAINERS
Message-ID: <20080704085014.GA678@digi.com>
References: <20080704063455.GA13999@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080704063455.GA13999@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 04 Jul 2008 08:50:15.0051 (UTC) FILETIME=[FA2205B0:01C8DDB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

now I scripted a bit and the result is at

	http://www.modarm9.com/git/people/ukleinek/linux-2.6.git?a=shortlog;h=refs/heads/maintainers

and

	git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git maintainers

.  Shortlog and diffstat are below.

Best regards
Uwe

Uwe Kleine-König (3):
      MAINTAINERS: fix format
      MAINTAINERS: fix alphabetic ordering
      MAINTAINERS: merge P: and M: fields to ease copy'n'paste


 MAINTAINERS | 3144 ++++++++++++++++++++++-------------------------------------
 1 files changed, 1189 insertions(+), 1955 deletions(-)
		
-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
