Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYIXNYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYIXNYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 09:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYIXNYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 09:24:20 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:50710 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYIXNYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 09:24:19 -0400
Date: Wed, 24 Sep 2008 10:24:32 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Gerhard Brauer <gerhard.brauer@web.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080924102432.22500367@doriath.conectiva>
In-Reply-To: <1222004499.4060.16.camel@tux1.brauer.lan>
References: <20080826141851.GA5300@tux1.brauer.lan>
	<20080826145338.GA8601@Krystal>
	<20080826131354.356ae11d@doriath.conectiva>
	<20080826171822.GB14906@Krystal>
	<20080826150222.0cf1542c@doriath.conectiva>
	<20080826181558.GA16887@Krystal>
	<20080826203449.GD5300@tux1.brauer.lan>
	<20080827161346.35b48d75@doriath.conectiva>
	<20080827233328.GC25531@Krystal>
	<20080828103013.163730ee@doriath.conectiva>
	<20080831092923.GB4305@tux1.brauer.lan>
	<20080831110942.7acaf82f@mandriva.com.br>
	<1222004499.4060.16.camel@tux1.brauer.lan>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.2; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 21 Sep 2008 15:41:39 +0200
Gerhard Brauer <gerhard.brauer@web.de> escreveu:

| Am Sonntag, den 31.08.2008, 11:09 -0300 schrieb Luiz Fernando N.
| Capitulino:
| 
| >  Mandriva kernel was 2.6.26.3 based at the time I started testing
| > this and all my last tests have been done on 2.6.27-rc4. I think it's
| > very unusual to have a change in a -stable kernel not present in the
| > latest -rc.
| 
| I was away the last days, but i notice that the virtualbox update to
| 2.0.2 solve all problems i mentioned. We also have same responses from
| other arch users.
| I never saw the "early boot oops" (this have had gone still with our
| kernel update, mystical....). But also the "heavy IO oops" has gone. So
| it was a virtualbox problem, they fixed it in:
| http://www.virtualbox.org/ticket/1875
| 
| So from my side this is solved.

 Yeah, we have ran some tests here as well and it is solved.

 Thanks a lot for the people involved in debugging this problem.

-- 
Luiz Fernando N. Capitulino
