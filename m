Return-Path: <linux-kernel-owner+w=401wt.eu-S1763168AbZE0Mun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763168AbZE0Mun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763360AbZE0MuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:50:25 -0400
Received: from www.tglx.de ([62.245.132.106]:38863 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763292AbZE0MuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:50:24 -0400
Date: Wed, 27 May 2009 14:49:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
cc: "riel@redhat.com" <riel@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: [tip:timers/urgent] NOHZ: Properly feed cpufreq ondemand
 governor
In-Reply-To: <1243426712.19944.165.camel@eenurkka-desktop>
Message-ID: <alpine.LFD.2.00.0905271449400.3397@localhost.localdomain>
References: <12432346571351-git-send-email-ext-eero.nurkkala@nokia.com>  <tip-4e67ac87c460a3c876019fa05149591122ec5287@git.kernel.org> <1243426712.19944.165.camel@eenurkka-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Eero Nurkkala wrote:
> 
> A quick note:
> Now ts is uninitialized? So ts->inidle could cause troubles, no?

/me is a moron. 
