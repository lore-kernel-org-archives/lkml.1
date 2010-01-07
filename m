Return-Path: <linux-kernel-owner+w=401wt.eu-S1751067Ab0AGRRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab0AGRRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776Ab0AGRRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:17:18 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:41759 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0AGRRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:17:17 -0500
Date: Thu, 7 Jan 2010 11:16:36 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 3/4] Optimized add_local()
In-Reply-To: <20100105225930.GD32584@Krystal>
Message-ID: <alpine.DEB.2.00.1001071115470.901@router.home>
References: <20100105220417.400092933@quilx.com> <20100105220439.030792114@quilx.com> <20100105225930.GD32584@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Mathieu Desnoyers wrote:

> add_local can be implemented with the "add" instruction, which is
> significantly faster if my memory serves me correctly.

Yes a full patchset would do that. Lets first see if we can come to an
agreement to go down this road before I put the effort in.

