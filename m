Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYKDPrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYKDPrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYKDPrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:47:07 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:39809 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbYKDPrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:47:05 -0500
Date: Tue, 4 Nov 2008 13:48:32 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
Message-ID: <20081104134832.6c596d54@doriath.conectiva>
In-Reply-To: <20081103163311.GA2417@khazad-dum.debian.net>
References: <20081102040008.GB29606@khazad-dum.debian.net>
	<490D8C4E.3010201@tuffmail.co.uk>
	<20081102130655.GA12766@srcf.ucam.org>
	<20081103141628.GB31078@khazad-dum.debian.net>
	<20081103141836.GA31894@srcf.ucam.org>
	<490F0ACC.4000808@tuffmail.co.uk>
	<20081103145145.GD31078@khazad-dum.debian.net>
	<20081103145543.GA496@srcf.ucam.org>
	<20081103150229.GF31078@khazad-dum.debian.net>
	<20081103150843.GA1107@srcf.ucam.org>
	<20081103163311.GA2417@khazad-dum.debian.net>
Organization: Mandriva
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 3 Nov 2008 14:33:11 -0200
Henrique de Moraes Holschuh <hmh@hmh.eng.br> escreveu:

| On Mon, 03 Nov 2008, Matthew Garrett wrote:
| > On Mon, Nov 03, 2008 at 01:02:29PM -0200, Henrique de Moraes Holschuh wrote:
| > > Right now, you should still rfkill_force_state().  Please wait for an hour
| > > or two while I clean up that broken resume handling, and I will tell you for
| > > sure.
| > 
| > Cool. I'll hold off posting my cleanups until then in that case.
| 
| Ok, two bugs reproduced, the fixes are ready and tested, and I will be
| sending it now to linux-wireless.  You're in the CC, so you will get them.
| 
| I will also need to send patches for -stable, as the ones for mainline won't
| apply to -stable.

 Great.

 Do the patches have anything to do with the problem I have reported?

 Rafael has opened a bugzilla ticket for it:

http://bugzilla.kernel.org/show_bug.cgi?id=11928

-- 
Luiz Fernando N. Capitulino
