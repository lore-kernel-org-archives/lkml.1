Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZLARcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZLARcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZLARcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:32:52 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46245 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZLARcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:32:52 -0500
Date: Tue, 1 Dec 2009 11:32:55 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David John <davidjon@xenontk.org>
cc: linux-kernel@vger.kernel.org, Jonathan Miles <jon@cybus.co.uk>,
       penberg@cs.helsinki.fi
Subject: Re: OOM kernel behaviour
In-Reply-To: <4B154E10.7050300@xenontk.org>
Message-ID: <alpine.DEB.2.00.0912011132020.10859@router.home>
References: <4B1402FC.80307@cybus.co.uk> <4B1537CA.7020107@xenontk.org> <alpine.DEB.2.00.0912011007360.8841@router.home> <4B154E10.7050300@xenontk.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.0912011132022.10859@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some fixes to reclaim in 2.6.31.6 related to improper reclaim
of executable pages. Please try the latest point release with all fixes.


