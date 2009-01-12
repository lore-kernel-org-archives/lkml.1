Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbZALMsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbZALMsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZALMsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:48:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42661 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbZALMsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:48:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [Bug #12415] WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:689
Date: Mon, 12 Jan 2009 13:47:42 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <oWTznAnH9BI.A.nzH.SHfaJB@chimera> <200901121215.31749.borntraeger@de.ibm.com>
In-Reply-To: <200901121215.31749.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121347.42799.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009, Christian Borntraeger wrote:
> Am Sonntag 11 Januar 2009 schrieb Rafael J. Wysocki:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12415
> > Subject		: WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:689
> > Submitter	: Christian Borntraeger <borntraeger@de.ibm.com>
> > Date		: 2009-01-05 10:36 (7 days old)
> > References	: http://marc.info/?l=linux-wireless&m=123115178019082&w=4
> 
> Meanwhile I have updated the device firmware and the kernel level. The 
> problems has disappeared.

Thanks for the update, the bug has been closed.

Rafael
