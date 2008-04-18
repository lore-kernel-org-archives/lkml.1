Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYDRIaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYDRIaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYDRIab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:30:31 -0400
Received: from ic0245.upco.es ([130.206.70.245]:33392 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbYDRIaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:30:30 -0400
Subject: Re: [Suspend-devel] 2.6.25-rc6 regression - hang on resume
	[Bug	10319]
From: Romano Giannetti <romanol@upcomillas.es>
To: Stefan Seyfried <seife@suse.de>
Cc: Soeren Sonnenburg <kernel@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       suspend-devel@lists.sourceforge.net,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <480794D4.9020503@suse.de>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <pdYe6zNQVl.A.fp.nEW9HB@albercik> <1207290689.4511.1.camel@localhost>
	 <1207552602.26185.13.camel@pern>  <480794D4.9020503@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 18 Apr 2008 09:34:00 +0200
Message-Id: <1208504040.29641.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2008-04-17 at 20:20 +0200, Stefan Seyfried wrote:

> can you try if this patch to libx86 (make sure it gets installed and used...)
> fixes the problem?
> 
> Index: libx86-0.99/x86-common.c

Sorry to be a bit though, but _what_ I'm supposed to patch? It's in
s2ram sources? Thanks!

Romano

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
