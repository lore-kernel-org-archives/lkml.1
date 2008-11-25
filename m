Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYKYLBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYKYLBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYKYLBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:01:34 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:35661 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYKYLBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:01:33 -0500
Message-ID: <492BDB0A.80203@upcomillas.es>
Date: Tue, 25 Nov 2008 12:01:30 +0100
From: "Romano Giannetti (lists)" <romanol@upcomillas.es>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andreas Mohr <andi@lisas.de>, Bernhard Schmidt <berni@birkenwald.de>,
       devsk <kernel-bugs.dev1world@spamgourmet.com>,
       Johan Bilien <jobi@via.ecp.fr>
Subject: Re: [Bug #11947] 2.6.28-rc VC switching with Intel graphics broken
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.IHD.O8HKJB@chimera> <492A6A20.4080106@upcomillas.es> <200811241101.55121.jbarnes@virtuousgeek.org>
In-Reply-To: <200811241101.55121.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[resent - sorry, LKML sent it back --- my bad]
Jesse Barnes wrote:
> 
> Just added to the bug, it looks like a DUP of an issue Keith just fixed last 
> week (now to make sure the patch makes it upstream quickly).
> 
Tried the patch and tested, it works ok. VC switching and suspend/resume 
fixed. More details on bugzilla.

Tested-by: Romano Giannetti <romano.giannetti@gmail.com>

Thanks to all!
     Romano

-- 
Sorry for the disclaimer --- ¡I cannot stop it!


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
