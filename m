Return-Path: <linux-kernel-owner+w=401wt.eu-S1762310AbZCaVBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762310AbZCaVBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZCaVBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:01:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56912 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760521AbZCaVBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:01:04 -0400
MIME-Version: 1.0
In-Reply-To: <49D280EF.1080507@oracle.com>
References: <49D280EF.1080507@oracle.com>
Date: Tue, 31 Mar 2009 23:01:00 +0200
Message-ID: <897274600903311401v65fe3d3ame8522226a8a71ca9@mail.gmail.com>
Subject: Re: 2.6.29 boot hang
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, andreas.herrmann3@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/31 Randy Dunlap <randy.dunlap@oracle.com>:

> If I change CONFIG_MICROCODE_AMD=y to CONFIG_MICROCODE_AMD=n & rebuild,
> the kernel boots successfully.
>
> Suggestions, fixes, etc.??
>

Does it boot with 2.6.28 and CONFIG_MICROCODE_AMD=y ?

If it is booting with 2.6.28 and AMD=y it could be a linux kernel
related problem.

-

Morten
