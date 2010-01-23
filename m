Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968Ab0AWPsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0AWPsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 10:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794Ab0AWPsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 10:48:52 -0500
Received: from lucidpixels.com ([75.144.35.66]:46005 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab0AWPsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 10:48:51 -0500
Date: Sat, 23 Jan 2010 10:48:50 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: High pitch noise when ACPI processor module is loaded.
Message-ID: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linux:
When I do not load the ACPI processor module, there is no high pitch 
noise.  When I load the ACPI processor module (so I can utilize Turbo 
Boost), Linux makes the system emit a high pitch noise.

Windows:
The same system, running Windows 7 does not emit any noise.

Is there something wrong with the ACPI processor module or its 
implementation on i5/i7 CPUs?

Justin.
