Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYAGR1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYAGR1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYAGR1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:27:31 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:55377 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYAGR1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:27:31 -0500
Message-ID: <478260C9.6040407@s5r6.in-berlin.de>
Date: Mon, 07 Jan 2008 18:26:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Michal Simek <simekm2@fel.cvut.cz>,
       linux-kernel@vger.kernel.org, monstr@monstr.eu
Subject: Re: New linux arch
References: <47820D24.3060800@fel.cvut.cz> <84144f020801070447t68808bcdq64bfc949c7732462@mail.gmail.com> <Pine.LNX.4.64.0801071433510.14194@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801071433510.14194@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>>On Jan 7, 2008 1:29 PM, Michal Simek <simekm2@fel.cvut.cz> wrote:
>>> Is it possible to create git repository in git.kernel.org for Microblaze
>>> cpu?
...
> Alternatively, providing your own git service is just as effective,
> and comes with much more freedom :)

It is /almost/ as effective:
  - Many of the git trees on kernel.org are set up to share objects with
Linus' tree.
  - The tree owners can fetch from each other locally and via ssh:
protocol, alternatively to the remote protocols.

But it is exactly as effective in terms of the workflow organization.
-- 
Stefan Richter
-=====-==--- ---= --===
http://arcgraph.de/sr/
