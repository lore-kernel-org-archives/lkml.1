Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbZCBRXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbZCBRXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758367AbZCBRXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:23:22 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:43554 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243AbZCBRXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:23:21 -0500
Date: Mon, 2 Mar 2009 17:23:09 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
       davej@redhat.com
Subject: Re: 2.6.28 - 2.6.29-rc6-git5 regression, p4-clockmod/cpufreq probably
Message-ID: <20090302172309.GC25965@silver.sucs.org>
References: <200903021704.59663.denys@visp.net.lb> <200903021815.56191.denys@visp.net.lb> <20090302162621.GB25965@silver.sucs.org> <200903021833.46540.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903021833.46540.denys@visp.net.lb>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 06:33:46PM +0200, Denys Fedoryschenko wrote:
> CPUFreq infrastructure much more powerful.
> -d --min <FREQ>
>     new minimum CPU frequency the governor may select. 
> -u --max <FREQ>
>     new maximum CPU frequency the governor may select. 
> -g --governor <GOV>
>     new cpufreq governor. 
> 
> This things you cannot do over inserting values over ACPI. Sure you can 
> reinvent the wheel, but why?

I guess I don't understand why you would want scaling if it didn't save
you any power...

-- 
Sitsofe | http://sucs.org/~sits/
