Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbYDWJmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbYDWJmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYDWJms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:42:48 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:56030 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYDWJmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:42:47 -0400
Subject: Re: [git pull] scheduler changes for v2.6.26
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frans Pop <elendil@planet.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Richard Jonsson <richie@coderworld.net>
In-Reply-To: <200804231136.50639.elendil@planet.nl>
References: <20080419181304.GB21353@elte.hu>
	 <200804211831.29976.elendil@planet.nl> <20080421194359.GD8770@elte.hu>
	 <200804231136.50639.elendil@planet.nl>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 11:42:44 +0200
Message-Id: <1208943764.7115.330.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 11:36 +0200, Frans Pop wrote:

> BTW, did either of you actually look at the traces I sent for .24? I never 
> got any feedback on those.

Yes, but those traces were << 1s and didn't appear to contain the jumps.

