Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZLHLTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZLHLTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZLHLTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:19:12 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:62857 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZLHLTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:19:11 -0500
Subject: Re: [PATCH] ASoC: Wrong variable returned on error
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: javier.martin@vista-silicon.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1D9F0E.4010009@gmail.com>
References: <4B1D9F0E.4010009@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 11:19:11 +0000
Message-ID: <1260271151.3119.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 01:34 +0100, Roel Kluin wrote:
> The wrong variable was returned in the case of an error
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>




