Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbZDFXNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbZDFXNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 19:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZDFXMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 19:12:55 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58184 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZDFXMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 19:12:55 -0400
Date: Tue, 7 Apr 2009 00:13:22 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [Bug #13019] /proc/<pid>/maps offset output broken in 2.6.29
In-Reply-To: <AsKNxFx2juN.A.9HH.zFn2JB@chimera>
Message-ID: <Pine.LNX.4.64.0904070008320.4254@blonde.anvils>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.9HH.zFn2JB@chimera>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13019
> Subject		: /proc/<pid>/maps offset output broken in 2.6.29
> Submitter	: "Chris Friesen" <cfriesen@nortel.com>
> Date		: 2009-04-01 23:18 (6 days old)
> References	: http://marc.info/?l=linuxppc-embedded&m=123862902916059&w=4
> Handled-By	: Hugh Dickins <hugh@veritas.com>

No, this shouldn't be listed as a regression from 2.6.28: if it's to be
counted as a regression at all, it's 2.6.23's regression from 2.6.22.
(We're about to deal with it in 2.6.30, but hardly worth backporting.)

Hugh
