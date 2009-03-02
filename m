Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZCBQHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZCBQHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZCBQHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:07:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60944 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZCBQHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:07:05 -0500
Date: Mon, 2 Mar 2009 16:06:59 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       cpufreq@vger.kernel.org, davej@redhat.com
Subject: Re: 2.6.28 - 2.6.29-rc6-git5 regression, p4-clockmod/cpufreq probably
Message-ID: <20090302160658.GA32708@srcf.ucam.org>
References: <200903021704.59663.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903021704.59663.denys@visp.net.lb>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 05:04:59PM +0200, Denys Fedoryschenko wrote:

> On 2.6.29-rc6 (git5 tested also) also shown in dmesg as available, but i  
> can't change anything.

That's deliberate. p4-clockmod is for thermal management, not clock 
control (since it doesn't actually do any of that)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
