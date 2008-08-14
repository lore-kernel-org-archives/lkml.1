Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbYHNL4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbYHNL4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 07:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbYHNL4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 07:56:36 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:50858 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbYHNL4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 07:56:35 -0400
Date: Thu, 14 Aug 2008 13:56:20 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: sysprof in 2.6.27 kernel
Message-ID: <20080814115620.GD4674@ics.muni.cz>
References: <20080813083953.GF19333@ics.muni.cz> <ye8myjg7b4r.fsf@camel10.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ye8myjg7b4r.fsf@camel10.daimi.au.dk>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 14 Aug 2008 13:56:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 01:23:16AM +0200, Soeren Sandmann wrote:
> It's somewhat rough still. If you try it out, I will be interested in
> any feedback you have.

and another one. sysproc gui reads user addresses from the sysprof pipe with
null pointers. is this ok or is this a bug in sysprof kernel module?

-- 
Luká¹ Hejtmánek
