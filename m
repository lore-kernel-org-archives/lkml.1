Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbYJYABx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbYJYABx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 20:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYJYABp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 20:01:45 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57418 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYJYABp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 20:01:45 -0400
Subject: Re: 2.6.27-git7 compile error (ppc)
From: Badari Pulavarty <pbadari@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Kumar Gala <galak@kernel.crashing.org>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <49025275.4050102@nortel.com>
References: <1224265634.15582.3.camel@badari-desktop>
	 <1224267073.15582.8.camel@badari-desktop>
	 <FEFFA236-AA3B-49F1-AED2-E42950B87BD7@kernel.crashing.org>
	 <200810250054.05849.rjw@sisk.pl>  <49025275.4050102@nortel.com>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 17:02:29 -0700
Message-Id: <1224892949.16003.30.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 16:55 -0600, Chris Friesen wrote:
> Rafael J. Wysocki wrote:
> > On Friday, 17 of October 2008, Kumar Gala wrote:
> 
> >> I've got a patch that seems to address this for me building w/ 
> >> CONFIG_RELOCATABLE on ppc32/85xx.
> > 
> > Has that been fixed in 2.6.27 and/or current mainline?
> 
> I think CONFIG_RELOCATABLE was introduced post 2.6.27, so shouldn't be a 
> problem in that version.
> 
> Chris

Not quite true. CONFIG_RELOCATABLE is present in 2.6.27, but the changes
to types.h happend post 2.6.27 - so there is no problem with 2.6.27.

2.6.27-git11 compiles fine.

Thanks,
Badari

