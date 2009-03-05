Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZCEJGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZCEJGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZCEJG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:06:28 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:38943 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbZCEJG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:06:26 -0500
Date: Thu, 5 Mar 2009 10:06:18 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Markus <M4rkusXXL@web.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Zdenek Kabelac <zkabelac@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: drop_caches ...
Message-ID: <20090305090618.GB23266@ics.muni.cz>
References: <200903041057.34072.M4rkusXXL@web.de> <200903041447.49534.M4rkusXXL@web.de> <49AE8BA8.3080504@redhat.com> <200903041947.41542.M4rkusXXL@web.de> <20090305004850.GA6045@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090305004850.GA6045@localhost>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 05 Mar 2009 10:06:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 05, 2009 at 08:48:50AM +0800, Wu Fengguang wrote:
> Markus, you may want to try this patch, it will have better chance to figure
> out the hidden file pages.

just for curiosity, would it be possible to print process name which caused
the file to be loaded into caches?

-- 
Luká¹ Hejtmánek
