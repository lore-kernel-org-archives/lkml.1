Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbYLDKza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbYLDKza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYLDKzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:55:13 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:39850 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbYLDKzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:55:10 -0500
Message-ID: <4937B70B.1000101@upcomillas.es>
Date: Thu, 04 Dec 2008 11:55:07 +0100
From: "Romano Giannetti (lists)" <romanol@upcomillas.es>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andreas Mohr <andi@lisas.de>, Bernhard Schmidt <berni@birkenwald.de>,
       devsk <kernel-bugs.dev1world@spamgourmet.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Johan Bilien <jobi@via.ecp.fr>
Subject: Re: [Bug #11947] 2.6.28-rc VC switching with Intel graphics broken
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera> <bfPM5B8Tx2B.A.6t.KqxNJB@chimera>
In-Reply-To: <bfPM5B8Tx2B.A.6t.KqxNJB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11947
> Subject		: 2.6.28-rc VC switching with Intel graphics broken
> Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
> Date		: 2008-11-03 12:10 (31 days old)
> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> 

It is fixed for me in -rc7-105 (to be exact, it seems that commit 52440211dc 
fixed it), but there are more people with a very similar problem still unfixed.

Romano

-- 
Sorry for the disclaimer --- ¡I cannot stop it!


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
