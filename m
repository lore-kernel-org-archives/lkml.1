Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZLRQMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZLRQMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZLRQMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:12:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62670 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbZLRQMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:12:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fqL6PzA+30Qio3W4zkNmgLmadLZTNksW8cpq2Pc8fdD2i/tH5MAg3AE4gJ2AlKc1QL
         +Ux+VC4Kg0UbvOrBTIAGomG2j6JaWUhfYaeJ+AJtaAvA37tXmOXzCB2eu/oa8wgL0HkX
         pbucGrQXdXOL2re9j1idbZTzwUeLgp96pgiXU=
Subject: Re: [PATCH 2/4] mfd: mc13783: When probing, unlock the mc13783
 before subsystems initialisation.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>
In-Reply-To: <1260811085.2022.135.camel@climbing-alby>
References: <1260808880.2022.98.camel@climbing-alby>
	 <1260810776.2022.130.camel@climbing-alby>
	 <1260811085.2022.135.camel@climbing-alby>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 17:12:26 +0100
Message-ID: <1261152746.3356.72.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping :)

PATCH 1 & 2 are fixes that can go to .33

Thanks for the time giving to this.

Alberto!

