Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbXKAL4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbXKAL4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 07:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbXKAL4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 07:56:48 -0400
Received: from ic0245.upco.es ([130.206.70.245]:33826 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXKAL4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 07:56:47 -0400
Subject: 2.6.34-rc1 eat my photo SD card :-(
From: Romano Giannetti <romanol@upcomillas.es>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 01 Nov 2007 12:56:42 +0100
Message-Id: <1193918202.8439.7.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

	I have a very possible regression to signal. This morning 2.6.24-rc1
eat and destroyed my SD card. I have a toshiba laptop with a card slot
and I have used it with 2.6.23-rcX and 2.6.23 without problems so far.
This morning I put the card in, nothing happened, removed it. When I put
it in again the filesystem in it was completely scr***ed up. 

I have a flight waiting now, so I have put all the dmesgs and syslogs
over there:

http://www.dea.icai.upcomillas.es/romano/linux/info/2624-rc1-mmc/

Sunday I'll be back to help debug it.

Thank you very much

	Romano 

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
