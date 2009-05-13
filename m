Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbZEMKGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbZEMKGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbZEMKGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:06:33 -0400
Received: from av-gw1.cc.tut.fi ([130.230.130.110]:33895 "EHLO
	av-gw1.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666AbZEMKGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:06:32 -0400
X-AuditID: 82e6826e-a76c8bb0000009be-42-4a0a9b9f9fc6 
Date: Wed, 13 May 2009 13:06:22 +0300
From: Petri Kaukasoina <kaukasoina704m93hd7@sci.fi>
To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Clark Williams <williams@redhat.com>, zippel@linux-m68k.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
Message-ID: <20090513100622.GC22832@elektroni.phys.tut.fi>
Mail-Followup-To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Clark Williams <williams@redhat.com>, zippel@linux-m68k.org,
	Ingo Molnar <mingo@elte.hu>
References: <alpine.LFD.2.00.0905130027530.3561@localhost.localdomain> <4A0A9A23.24720.54D53C4@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de> <20090513092335.GA22832@elektroni.phys.tut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513092335.GA22832@elektroni.phys.tut.fi>
User-Agent: Mutt/1.4.2.3i
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 12:23:35PM +0300, Petri Kaukasoina wrote:
> 100 ppm making a difference of 17 seconds a day.

Sorry, 200 ppm is 17 seconds. 100 ppm is just 8.6 s.

-Petri
