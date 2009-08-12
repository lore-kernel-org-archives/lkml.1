Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbZHLLUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbZHLLUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbZHLLUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:20:35 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:39555 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZHLLUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:20:34 -0400
Date: Wed, 12 Aug 2009 13:20:20 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
Message-ID: <20090812112020.GB10800@braap.org>
References: <20090810152606.GA23319@braap.org> <4A804B0B.5020809@gefanuc.com> <20090810203637.GD3055@braap.org> <4A8133ED.6070304@gefanuc.com> <20090811094025.GC3251@braap.org> <4A81683D.2030408@gefanuc.com> <20090811210146.GB9910@braap.org> <4A827A84.3060906@gefanuc.com> <20090812093949.GB2604@braap.org> <4A8291F5.8060406@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8291F5.8060406@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> However, I also need to consider other cases, such as communications  
> between multiple SBCs and potentially a few slave devices. I have a need  
> for this *now*, not in the future. To me, slave support and to a lesser  
> degree location monitor support is important now, hence why it's  
> supported in my driver and core. Hence why I am asking, how do you  
> propose to support these features?

Point taken.

Could you tell me a bit more about your needs on this respect?
So, you have multiple SBCs (some of them as masters, some others
as slaves) running Linux and want to communicate between them?
Have you got working code for all that?

E.
