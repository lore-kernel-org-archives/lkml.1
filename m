Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZLHM4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZLHM4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZLHM4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:56:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44574 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754492AbZLHM4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:56:34 -0500
Date: Tue, 8 Dec 2009 12:56:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: javier.martin@vista-silicon.com, Liam Girdwood <lrg@slimlogic.co.uk>,
       alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: Wrong variable returned on error
Message-ID: <20091208125639.GA1844@rakim.wolfsonmicro.main>
References: <4B1D9F0E.4010009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D9F0E.4010009@gmail.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 01:34:22AM +0100, Roel Kluin wrote:
> The wrong variable was returned in the case of an error
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied, thanks.
