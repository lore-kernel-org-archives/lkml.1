Return-Path: <linux-kernel-owner+w=401wt.eu-S934929AbXGLUpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934929AbXGLUpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbXGLUpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:45:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:55635 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbXGLUpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:45:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,533,1175497200"; 
   d="scan'208";a="105678679"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: S3 state transition
Date: Thu, 12 Jul 2007 13:45:10 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD6284C73D2@scsmsx412.amr.corp.intel.com>
In-Reply-To: <20070712141349.GB3881@ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: S3 state transition
Thread-Index: AcfEj0NZ+4fsVDPLQvilKPGV+ArokAANixsw
References: <A3258B497F1C1441AD36A2E8B45FD628486D78@scsmsx412.amr.corp.intel.com> <20070712141349.GB3881@ucw.cz>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Jul 2007 20:45:11.0002 (UTC) FILETIME=[8A3A33A0:01C7C4C5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I searched the archives but couldn't get much. Can you point me to code?

Thanks,
Lomesh

-----Original Message-----
From: Pavel Machek [mailto:pavel@ucw.cz] 
Sent: Thursday, July 12, 2007 7:14 AM
To: Agarwal, Lomesh
Cc: linux-kernel@vger.kernel.org
Subject: Re: S3 state transition

On Wed 2007-07-11 16:15:37, Agarwal, Lomesh wrote:
> I am trying to understand how Linux handles S3 state transition.
> Specially I want to understand what it does anything for processes
> loaded at the time of transition. Any pointers to code/document will
be
> helpful.

Do you mean suspend2ram? Search archives for freezer flamewar.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
