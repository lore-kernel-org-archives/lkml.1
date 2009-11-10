Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZKJKNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZKJKNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZKJKN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:13:29 -0500
Received: from forum.psychotherapie.org ([217.160.22.205]:54258 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbZKJKN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:13:29 -0500
Date: Tue, 10 Nov 2009 11:10:00 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
Message-ID: <20091110101000.GC575@nibiru.local>
Reply-To: weigelt@metux.de
References: <1257230619.5063.42.camel@eric-desktop.grokthis.net> <1257247265.23142.21.camel@tara.firmix.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257247265.23142.21.camel@tara.firmix.at>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bernd Petrovitsch <bernd@firmix.at> wrote:

> The only remotely useful benefit in the long run I can imagine is: The
> permanent cross-compiling will make AC_TRY_RUN() go away. Or at least
> the alternatives are applicable without reading the generated
> configure.sh (and config.log) to guess how to tell the script some
> details.

hmm, that could be the real killer argument - evolutionarily 
sort out the guys who're too dumb to write proper buildscripts ;-)


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
