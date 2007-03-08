Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbXCHFqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbXCHFqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 00:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbXCHFqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 00:46:31 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:39523 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbXCHFqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 00:46:30 -0500
Message-ID: <45EFA384.5050509@drzeus.cx>
Date: Thu, 08 Mar 2007 06:47:48 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC: -mm patch] #if 0 mmc_deselect_cards()
References: <20070306004408.d3f6434d.akpm@linux-foundation.org> <20070307224111.GD3441@stusta.de>
In-Reply-To: <20070307224111.GD3441@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Mar 06, 2007 at 12:44:08AM -0800, Andrew Morton wrote:
>> ...
>> Changes since 2.6.20-rc2-mm1:
>> ...
>>  git-mmc.patch
>> ...
>>  git trees
>> ...
> 
> mmc_deselect_cards() is no longer used.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 

Indeed, but it's probably better to just remove it rather than have old crud
lying around.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
