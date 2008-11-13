Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYKMO7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYKMO7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYKMO7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:59:06 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:3498 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYKMO7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:59:05 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Date: Thu, 13 Nov 2008 09:58:17 -0500
Message-Id: <20081113145433.M82585@bobcopeland.com>
In-Reply-To: <491B17B3.204@gmail.com>
References: <491506DB.1070000@gmail.com>	 <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>	 <4918A8C5.3050607@gmail.com> <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com> <491B17B3.204@gmail.com>
X-Mailer: OpenWebMail 2.53 
X-OriginatingIP: 149.101.1.135 (bob)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 19:51:47 +0200, Maxim Levitsky wrote
> >> Why it doesn't accept new mac?, can this be fixed?
> 
> Any update on mac changer status?

Yeah, we appear to only set the mac address at probe time to the one in the
eeprom.  It should be easy enough to fix.

-- 
Bob Copeland %% www.bobcopeland.com


