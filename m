Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZBKIPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZBKIPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZBKIPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:15:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53198 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZBKIPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:15:22 -0500
Date: Wed, 11 Feb 2009 09:32:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Cordes <peter@cordes.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_OPTIMIZE_INLINING fun
Message-ID: <20090211083217.GQ14832@one.firstfloor.org>
References: <Pine.LNX.4.64.0811141804030.29883@blonde.site> <87zlk1yvjk.fsf@basil.nowhere.org> <Pine.LNX.4.64.0811151504580.10293@blonde.site> <20090211042758.GV21351@cordes.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211042758.GV21351@cordes.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the detailed analysis.

It would be probably most productive if you could extract
compileable test cases and file them in gcc bugzilla, so that the gcc 
developers can address these problems.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
