Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbXHQTAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbXHQTAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbXHQTAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:00:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33168 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbXHQTAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:00:20 -0400
Subject: Re: SVr4/SVID/SUS IPC conformance
From: Arjan van de Ven <arjan@infradead.org>
To: Anton Arapov <aarapov@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <h8ps1mm64v.fsf@pepelac.englab.brq.redhat.com>
References: <h8ps1mm64v.fsf@pepelac.englab.brq.redhat.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 17 Aug 2007 11:56:11 -0700
Message-Id: <1187376971.2615.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-08-17 at 19:18 +0200, Anton Arapov wrote:
> 
>   IPC code is good, EIDRM is justification of EINVAL. But neither SVr4 nor SVID \
> documents EIDRM.   Single Unix Specification mentions EINVAL but not EIDRM as a \
> possible failure for shmctl(), so the current kernel behavior is not merely \
> self-inconsistent but a flat violation of the spec. 

these specs tend to always allow additional error codes.


