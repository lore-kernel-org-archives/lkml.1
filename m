Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYDPS7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYDPS7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYDPS7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:59:11 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3882 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbYDPS7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:59:10 -0400
Date: Wed, 16 Apr 2008 14:37:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, ivdoorn@gmail.com
Subject: Re: [GIT PATCH] rfkill support for r/w and r/o rfkill switches
Message-ID: <20080416183705.GA16123@tuxdriver.com>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 05:37:16PM -0300, Henrique de Moraes Holschuh wrote:
> 
> This patch series (based on v2.6.25-rc8-mm2) has several improvements to
> the rfkill class that I need for thinkpad-acpi, plus two fluff and
> documentation fixes.

Who is handling these rfkill patches?  I think in the past they have
gone through me, but some may have gone directly to Dave M.

If they are coming to me, please collect Ivo's ACKs and resend them
to linux-wireless@vger.kernel.org with me CC'ed as well.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
