Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbYLYMFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbYLYMFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 07:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYLYMFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 07:05:06 -0500
Received: from zakalwe.fi ([80.83.5.154]:41853 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbYLYMFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 07:05:05 -0500
X-Greylist: delayed 1221 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Dec 2008 07:05:05 EST
Date: Thu, 25 Dec 2008 13:44:43 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.6.1
Message-ID: <20081225114443.GD6115@zakalwe.fi>
References: <7v7i5odams.fsf@gitster.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <7v7i5odams.fsf@gitster.siamese.dyndns.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 10:36:27PM -0800, Junio C Hamano wrote:
> * The packfile machinery hopefully is more robust when dealing with
>   corrupt packs if redundant objects involved in the corruption are
>   available elsewhere.

Has anyone written a summary of how Git's redundancy operates?

* What would be the probability for a single bit flip to corrupt the 
repository?

* And what is the situation where a single bit flip can not corrupt the 
database?

* When (which commands/functions) is error detection done?

Heikki
