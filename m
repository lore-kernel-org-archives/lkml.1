Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbZKHAyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbZKHAyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 19:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbZKHAyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 19:54:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46270 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZKHAyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 19:54:52 -0500
Date: Sun, 8 Nov 2009 00:54:38 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Renninger <trenn@suse.de>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@gmail.com,
       Reinette Chatre <reinette.chatre@intel.com>,
       Aeolus Yang <Aeolus.Yang@atheros.com>,
       Amod Bodas <Amod.Bodas@atheros.com>,
       David Quan <David.Quan@atheros.com>,
       Kishore Jotwani <Kishore.Jotwani@atheros.com>
Subject: Re: [PATCH] cpu-freq: add troubleshooting section for FSB changes
Message-ID: <20091108005438.GA19638@srcf.ucam.org>
References: <1257537660-5301-1-git-send-email-lrodriguez@atheros.com> <200911072152.57596.trenn@suse.de> <4AF5F47C.5000402@linux.intel.com> <200911072347.05786.trenn@suse.de> <4AF5FBC7.9000105@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF5FBC7.9000105@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The described problem was one of significant throughput reduction when 
speedstep was enabled in the BIOS on a mobile system - the idea here was 
just to document how to identify whether the issue is down to cpu 
frequency scaling or some platform side effect.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
