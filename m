Return-Path: <linux-kernel-owner+w=401wt.eu-S933779AbXHWABS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779AbXHWABS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXHWABI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:01:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57024 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760473AbXHWABH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:01:07 -0400
Date: Wed, 22 Aug 2007 16:55:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       cpufreq@www.linux.org.uk, frank@harenberg.ch
Subject: Re: [Bugme-new] [Bug 8924] New: module speedstep-centrino does not
 load
Message-ID: <20070822165519.10ec5d68@laptopd505.fenrus.org>
In-Reply-To: <20070822164451.1481d745.akpm@linux-foundation.org>
References: <bug-8924-10286@http.bugzilla.kernel.org/>
	<20070822164451.1481d745.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 16:44:51 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> > Problem Description: modprobe speedstep-centrino quits with error
> > "no such device"


does the acpi-cpufreq driver work? on such new hardware that really
should be used rather than the legacy-hw speedstep-centrino
