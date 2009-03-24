Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbZCXMcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbZCXMcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbZCXMcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:32:33 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:48198 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZCXMcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:32:32 -0400
Date: Tue, 24 Mar 2009 13:32:29 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Re: tg3 driver fails to load firmware (2.6.29)
Message-ID: <20090324123229.GW12613@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20090324120948.GO12613@charite.de> <20090324121608.19f71ce2@lxorguk.ukuu.org.uk> <20090324122211.GS12613@charite.de> <20090324122900.06efc50d@lxorguk.ukuu.org.uk> <20090324123137.GV12613@charite.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090324123137.GV12613@charite.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>:
> * Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > > > Is your userspace configured to use /lib/firmware/2.6.29 or the more
> > > > usual /lib/firmware/ ?
> > > 
> > > Which leads to the next question: How to I find out?
> > 
> > Consult your distribution ? or stick it in both places and see 8)
> 
> Did that. No workee.

I mean, loading the firmware is not SOOO important. The thing that
annoys me is the 60 delay introduced by that.

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12200 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  Ralf.Hildebrandt@charite.de | http://www.charite.de
