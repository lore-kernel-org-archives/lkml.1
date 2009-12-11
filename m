Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbZLKOKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbZLKOKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbZLKOKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:10:40 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:48136 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881AbZLKOKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:10:40 -0500
Date: Fri, 11 Dec 2009 08:10:39 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Con Kolivas <kernel@kolivas.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
In-Reply-To: <200912111124.18118.kernel@kolivas.org>
Message-ID: <alpine.DEB.2.00.0912110809320.32415@router.home>
References: <200912111124.18118.kernel@kolivas.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Could you make the scheduler build time configurable instead of replacing
the existing one? Embedded folks in particular may love a low footprint
scheduler.

