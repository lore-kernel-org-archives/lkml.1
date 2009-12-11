Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbZLKKfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbZLKKfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbZLKKfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:35:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50754 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757447AbZLKKfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:35:37 -0500
Date: Fri, 11 Dec 2009 10:35:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Cc: lrg@slimlogic.co.uk, dbrownell@users.sourceforge.net,
       sameo@linux.intel.com, linux-kernel@vger.kernel.org,
       peter.de-schrijver@nokia.com, eduardo.valentin@nokia.com
Subject: Re: [PATCH 1/1] twl4030-regulator: extend twlreg_info to contain
 turnon delay and remap
Message-ID: <20091211103537.GC18825@rakim.wolfsonmicro.main>
References: <1260518031-11192-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260518031-11192-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
X-Cookie: Do not exceed recommended dosage.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 09:53:51AM +0200, Juha Keski-Saari wrote:
> Extend the twlreg_info structure to hold the turnon delay and remap config
> value for regulators, and implement turnon delay in reg_enable

Hrm, what exactly are these parameters?  Are they for inital power
sequencing or runtime things?

but for the default setting this does

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
