Return-Path: <linux-kernel-owner+w=401wt.eu-S1762279AbYERMbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762279AbYERMbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763275AbYERM1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:27:21 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:5207 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763468AbYERM1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:27:20 -0400
Date: Sun, 18 May 2008 14:27:17 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>, Avi Kivity <avi@qumranet.com>
Subject: Re: [Bug #10643] s390 kvm_virtio.c build error
Message-ID: <20080518122717.GB5577@osiris.boeblingen.de.ibm.com>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.Y6.HtBMIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7wuznNhcUqC.A.Y6.HtBMIB@albercik>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 01:13:55PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10643
> Subject		: s390 kvm_virtio.c build error
> Submitter	: Adrian Bunk <bunk@kernel.org>
> Date		: 2008-05-08 14:05 (11 days old)
> References	: http://lkml.org/lkml/2008/5/3/155
> Handled-By	: Heiko Carstens <heiko.carstens@de.ibm.com>
> Patch		:  several nearly identical patches, KVM tree should bring one

Still broken. Waiting for Avi's pull request.
