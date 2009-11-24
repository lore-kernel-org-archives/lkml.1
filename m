Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZKXB46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZKXB46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbZKXB45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:56:57 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:38049 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544AbZKXB45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:56:57 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_6kR9S3HC4hvqNW2rWXs2/w)"
Date: Mon, 23 Nov 2009 20:56:43 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Otavio Salvador <otavio@ossystems.com.br>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Vortex86SX: only works with irqpoll
In-reply-to: <be7a9f3d0911231601p4dcfa519q4d1504a8ee37fdad@mail.gmail.com>
Message-id: <alpine.LFD.2.00.0911232053070.858@localhost.localdomain>
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>
 <20091123134002.bac1e664.akpm@linux-foundation.org>
 <4B0B1B62.2030302@gmail.com>
 <be7a9f3d0911231601p4dcfa519q4d1504a8ee37fdad@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_6kR9S3HC4hvqNW2rWXs2/w)
Content-type: TEXT/PLAIN; charset=ISO-8859-1
Content-transfer-encoding: 8BIT

> >>> [    0.000000] ACPI Error: A valid RSDP was not found

Are there any BIOS SETUP options for enabling/disabling ACPI?

Does any other version of Linux, or any other OS find ACPI support?
does "acpidump" run as root output anything?

I couldn't follow your link to the BIOS manual, but if there
are some docs on this system that could tell us what the
hardware is and if it is supposed to suport ACPI or not,
that would be a clue.

thanks,
-Len Brown, Intel Open Source Technology Center

--Boundary_(ID_6kR9S3HC4hvqNW2rWXs2/w)--
