Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbZEOTdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbZEOTdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZEOTdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:33:45 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:47139 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751740AbZEOTdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:33:45 -0400
Date: Fri, 15 May 2009 15:33:35 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Ray Lee <ray-lk@madrabbit.org>
cc: Satish Eerpini <eerpini@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unresponsiveness on linux desktop during file copy
In-Reply-To: <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0905151533070.13433@qirst.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com> <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Ray Lee wrote:

> Which kernel version? If it's something recent, your programs may be
> getting swapped out due to a flaw in the latest kernels, where it
> accidentally prefers caching file data over mapped pages. If that's
> the case, Rik (cc:d) is working on patches to address the issue, and
> may appreciate another tester.

Please keep me in the loop. I'd be interested if those patches work and
what effect they have.


