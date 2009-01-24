Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbZAXWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbZAXWdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 17:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZAXWdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 17:33:23 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:46363 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbZAXWdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 17:33:22 -0500
Date: Sat, 24 Jan 2009 23:35:02 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: What happened to this NIC? Any ideas?
Message-ID: <20090124223502.GA27654@electric-eye.fr.zoreil.com>
Mail-Followup-To: Francois Romieu <romieu@fr.zoreil.com>,
	linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090124192450.GA4721@tatooine.rebelbase.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090124192450.GA4721@tatooine.rebelbase.local>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

markus reichelt <ml@mareichelt.de> :
[...]
> Just for the fun of it, I plugged the faulty NIC into a sole win
> machine, it worked. Doesn't work in the linux machine afterwards,
> though.

Was the faulty card was a 8139 and is 'lspci -vx' unable to recognize
it as such anymore ?

-- 
Ueimor
