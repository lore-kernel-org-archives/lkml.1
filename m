Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZBTSmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZBTSmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZBTSmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:42:10 -0500
Received: from rosi.naasa.net ([212.8.0.13]:52743 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZBTSmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:42:09 -0500
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Frans Pop <elendil@planet.nl>
Subject: Re: cpuinfo shows wrong MHz value
Date: Fri, 20 Feb 2009 19:42:00 +0100
User-Agent: KMail/1.9.9
Cc: Kasper Sandberg <lkml@metanurb.dk>, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Matthias-Christian Ott <ott@mirix.org>,
       cpufreq <cpufreq@www.linux.org.uk>
References: <200902142217.51655.jplatte@naasa.net> <200902191803.55347.jplatte@naasa.net> <200902200352.51173.elendil@planet.nl>
In-Reply-To: <200902200352.51173.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902201942.01681.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 20. Februar 2009 schrieb Frans Pop:

> It looks as if http://bugzilla.kernel.org/10968 has a fix for this issue,
> but that that patch never got included in the kernel.

Yes, this patch fixes the issue and the patch still applies to kernel 
2.6.28.6. Please push it into mainline.

regards and many thanks for providing this patch,
Jörg
