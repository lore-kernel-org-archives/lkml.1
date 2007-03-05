Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbXCEFLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbXCEFLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 00:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXCEFLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 00:11:06 -0500
Received: from mail4.kite.se ([212.214.165.225]:54841 "EHLO mail4.kite.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbXCEFLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 00:11:05 -0500
X-Greylist: delayed 1445 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2007 00:11:05 EST
Message-ID: <45EBA0BE.8070305@kite.se>
Date: Mon, 05 Mar 2007 05:46:54 +0100
From: "Magnus Naeslund(k)" <mag@kite.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Kirk Kuchov <kirk.kuchov@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
References: <20070301131118.GA30228@elte.hu>	 <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>	 <20070302081047.GA27122@2ka.mipt.ru>	 <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>	 <20070303100625.GA22557@2ka.mipt.ru>	 <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>	 <20070303203140.GA756@2ka.mipt.ru>	 <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>	 <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com>	 <Pine.LNX.4.64.0703041129550.3300@alien.or.mcafeemobile.com> <ca9528de0703041449x695a4c4bpc133d9afd5524019@mail.gmail.com>
In-Reply-To: <ca9528de0703041449x695a4c4bpc133d9afd5524019@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirk Kuchov wrote:
[snip]
> 
> This is a stupid comparaison. By your logic we should also have /dev/stdin,
> /dev/stdout and /dev/stderr.
> 

Well, as a matter of fact (on my system):

# ls -l /dev/std*
lrwxrwxrwx  1 root root 4 Feb  1  2006 /dev/stderr -> fd/2
lrwxrwxrwx  1 root root 4 Feb  1  2006 /dev/stdin -> fd/0
lrwxrwxrwx  1 root root 4 Feb  1  2006 /dev/stdout -> fd/1

Please don't bother to respond to this mail, I just saw that you 
apparently needed the info.

Magnus

P.S.: *PLONK*
