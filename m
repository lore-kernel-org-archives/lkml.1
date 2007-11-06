Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbXKFXKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbXKFXKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbXKFXJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:09:55 -0500
Received: from ic0245.upco.es ([130.206.70.245]:54353 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbXKFXJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:09:54 -0500
Subject: missing IBF_1 confirmations?
From: Romano Giannetti <romanol@upcomillas.es>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 07 Nov 2007 00:09:50 +0100
Message-Id: <1194390590.26583.4.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

	latest git (v2.6.24-rc1-748-g2655e2c) spams my logs with a message
like: 

SYS: Nov  6 23:55:21 rukbat kernel: [ 1479.474976] ACPI: EC: missing
IBF_1 confirmations,switch off interrupt mode.
SYS: Nov  6 23:55:21 rukbat kernel: [ 1479.475838] ACPI: EC: non-query
interrupt received, switching to interrupt mode

every now and then. 

(0)rukbat:~% dmesg | grep IBF_1 | wc -l
178

Is it dangerous? I didn't happen with a 2.6.24-rc1.

	Romano 

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
