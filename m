Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYC2AWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYC2AWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbYC2AWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:22:35 -0400
Received: from n72.bullet.mail.sp1.yahoo.com ([98.136.44.34]:44935 "HELO
	n72.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755572AbYC2AWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:22:34 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 883912.76616.bm@omp209.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3ZhpY4v7k+SdJuvJaYgKBgOWIdtxNP9tE7CMOt5l3tfgligWa+8okBVTr+MJnGoLxgzzCh3XLjXaSl3/Tb1CoYfFpdUXOlCqF/QOI5t5vC7zjv7aYM6iSjdFSU0t0tUjkcEVSi00LNMCxOn9y8AVquNSohQuGBxHkCsO+TfxTzo=;
X-YMail-OSG: klBdGnAVM1lDvbr0d.fSuXAMne8lzx_xJwiagZduhkJu3LUg5fTEVL67wqbVi3VgLQ--
Date: Fri, 28 Mar 2008 21:22:30 -0300 (ART)
From: Luis Sousa <ls.luis_sousa@yahoo.com.br>
Subject: Re: sata io freeze, 2.6.18 and also 2.6.24
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <610674.43534.qm@web46002.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Luis Sousa <ls.luis_sousa@yahoo.com.br> escreveu:

> --- Jeff Garzik <jeff@garzik.org> escreveu:
> 
> > Luis Sousa wrote:
> > > I've been having consistent hard system freezes for a
> > > long time, every 2 days or so, and finally decided to
> > > move to the most recent stable kernel. Unfortunatelly
> > > that didn't fix it. The freezes seem to be io-related;
> > > they started since I moved my drive to sata. They seem
> > > to happen mostly when there's an io-intensive operation,
> > > like extracting a big archive; a reboot is needed.
> > 
> > We need more info, namely full 'dmesg', 'lspci -v', and your kernel config.
> > 
> > Also, make /sure/ you are not running closed-source modules known to 
> > crash the system, like ndiswrapper or nvidia graphics driver.
> > 
> > 	Jeff
> 
> I'm quite sure.

Oops. My bad. I seem to actually be running the "nv" driver in xorg.conf. 
I had searched for "nvidia" before and so thought I had cleared that.
I didn't recall manually installing it this time. I'll try not using it.

--
Luis


      Abra sua conta no Yahoo! Mail, o único sem limite de espaço para armazenamento!
http://br.mail.yahoo.com/

