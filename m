Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbXFCVDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbXFCVDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 17:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbXFCVDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 17:03:24 -0400
Received: from mx.laposte.net ([81.255.54.16]:58127 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbXFCVDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 17:03:24 -0400
Date: Sun,  3 Jun 2007 23:03:00 +0200
Message-Id: <JJ2VT0$DB190600B73F354932BEAB2E7CA01539@laposte.net>
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
To: "ebiederm" <ebiederm@xmission.com>
Cc: "djwong" <djwong@us.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-XaM3-API-Version: 4.1 (B103)
X-SenderIP: 127.0.0.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This is just getting confusing.
> 
> Emmanuel Fust.  Please play with /proc/irq/*/smp_affinity by
and and
> confirm that you can move your irqs.  This will confirm it
is the decision
> part.
> 
Ok, as planned, you're right ;-) , playing with
/proc/irq/*/smp_affinity let me move irqs.

Emmanuel.
---

Créez votre adresse électronique prenom.nom@laposte.net 
1 Go d'espace de stockage, anti-spam et anti-virus intégrés.

