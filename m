Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZBRPV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZBRPV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZBRPVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:21:49 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:36826 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZBRPVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:21:48 -0500
Message-ID: <499C2782.2070801@s5r6.in-berlin.de>
Date: Wed, 18 Feb 2009 16:21:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       jeremy@goop.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, gitster@pobox.com, caglar@pardus.org.tr
Subject: Re: [PATCH] Add *.rej to .gitignore
References: <499B1729.5040802@goop.org> <20090217.143824.121552155.davem@davemloft.net> <20090218000506.GB12714@elte.hu> <20090218004039.GA30812@uranus.ravnborg.org> <20090218004919.GG25856@elte.hu>
In-Reply-To: <20090218004919.GG25856@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> My only beef is that i think i have a good workflow, still i 
> have no efficient automated defense against .rej files getting 
> into the tree.

Only workflows which do not involve pull requests are prone to this.
-- 
Stefan Richter
-=====-==--= --=- =--=-
http://arcgraph.de/sr/
