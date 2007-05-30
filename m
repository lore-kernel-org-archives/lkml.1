Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbXE3Nqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbXE3Nqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXE3Nqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:46:38 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:24659 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXE3Nqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:46:38 -0400
X-IronPort-AV: i="4.14,593,1170651600"; 
   d="scan'208"; a="31247528:sNHT6345791858"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 00/20] Blackfin update for 2.6.22-rc3
Date: Wed, 30 May 2007 09:48:31 -0400
User-Agent: KMail/1.9.5
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Bryan Wu" <bryan.wu@analog.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <11803414753217-git-send-email-bryan.wu@analog.com> <200705300909.13419.rgetz@blackfin.uclinux.org> <20070530133042.GA14693@uranus.ravnborg.org>
In-Reply-To: <20070530133042.GA14693@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705300948.31790.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 30 May 2007 13:45:52.0889 (UTC) FILETIME=[D70F8E90:01C7A2C0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30 May 2007 09:30, Sam Ravnborg pondered:
> Any possibility for you to provide cross-toolchain for x86?
> I have no plans running on actual HW but adding a bit more compile
> coverage would be great.

Pre-compiled tarballs, and rpms (debs comming soon), are at:

http://blackfin.uclinux.org/gf/project/toolchain/frs

Should already be in Gentoo's portage.

-Robin
