Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZG3VR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZG3VR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 17:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZG3VR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 17:17:26 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:50449 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbZG3VRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 17:17:25 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_AK1O+UZWLTncwx0ASWY4IQ)"
Date: Thu, 30 Jul 2009 17:17:11 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg@redhat.com>
Cc: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       bugzilla-daemon@bugzilla.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-15?Q?C=E9dric_Godin?= <cedric@belbone.be>
Subject: Re: [Bug 13865] [PATCH] hp-wmi: check that an input device exists in
 resume handler
In-reply-to: <20090730123711.GB14127@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.0907301716160.17818@localhost.localdomain>
References: <bug-13865-10028@http.bugzilla.kernel.org/>
 <200907292257.41573.rjw@sisk.pl> <200907301242.07973.elendil@planet.nl>
 <20090730123711.GB14127@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_AK1O+UZWLTncwx0ASWY4IQ)
Content-type: TEXT/PLAIN; charset=iso-8859-1
Content-transfer-encoding: 8BIT

> > Reported-and-tested-by: Cédric Godin <cedric@belbone.be>
> > Signed-off-by: Frans Pop <elendil@planet.nl>
> > Cc: Matthew Garrett <mjg59@srcf.ucam.org>

> Acked-by: Matthew Garrett <mjg@redhat.com>

Applied -- and i'll put it on my queue for 2.6.30.stable.

thanks,
Len Brown, Intel Open Source Technology Center

--Boundary_(ID_AK1O+UZWLTncwx0ASWY4IQ)--
