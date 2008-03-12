Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYCLUc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYCLUc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYCLUcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:32:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:34450 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbYCLUcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:32:46 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Date: Wed, 12 Mar 2008 16:31:29 -0400
User-Agent: KMail/1.9.9
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>,
       Adam Belay <abelay@novell.com>, Andi Kleen <andi@firstfloor.org>,
       Lee Revell <rlrevell@joe-job.com>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com> <20080305070201.0d16cd40@mjolnir.drzeus.cx> <20080305094023.6486ebdf@mjolnir.drzeus.cx>
In-Reply-To: <20080305094023.6486ebdf@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121631.30307.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll see if I can get around to some kind of power measurement (ideas for doing that in a sane way are still welcome btw).

Run BLTK.

http://www.lesswatts.org/projects/bltk/
