Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbZBNMee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbZBNMee (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 07:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbZBNMeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 07:34:25 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41041 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZBNMeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 07:34:25 -0500
Date: Sat, 14 Feb 2009 13:34:14 +0100
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] iwl breaking on suspend/resume,	regression from 2.6.29-rc3
Message-ID: <20090214123414.GA28933@gamma.logic.tuwien.ac.at>
References: <20090212130520.GA19991@gamma.logic.tuwien.ac.at> <1234456879.23593.131.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234456879.23593.131.camel@rc-desk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 12 Feb 2009, reinette chatre wrote:
> > [ 6921.233094] iwlagn: Could not load the INST uCode section
> > [ 6921.233097] iwlagn: Unable to set up bootstrap uCode: -110

> Could you please try
> http://marc.info/?l=linux-wireless&m=123429595818495&w=2 ?

That fixed the problem. Thanks.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
Windows NT crashed.
I am the Blue Screen of Death.
No one hears your screams.
                       --- Windows Error Haiku
