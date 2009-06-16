Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZFPN7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZFPN7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 09:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZFPN7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 09:59:00 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:35006 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbZFPN67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 09:58:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.42,228,1243807200";   d="scan'208";a="8278659"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: "'Lee Schermerhorn'" <Lee.Schermerhorn@hp.com>
Cc: "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       "'Brice Goglin'" <Brice.Goglin@inria.fr>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
 <87zldjn597.fsf@basil.nowhere.org>
 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
 <20090612103251.GJ25568@one.firstfloor.org>
 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
 <1245119977.6724.40.camel@lts-notebook>
In-reply-to: <1245119977.6724.40.camel@lts-notebook>
Subject: RE: [RFC PATCH 0/4]: affinity-on-next-touch
Date: Tue, 16 Jun 2009 15:58:57 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnuK7joXUArn5CyTaOZHz9Xl7JmowAXXYzA
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I would like to get these patches working with latest mmotm to test on
> some newer hardware where I think they will help more.  And I would
> welcome your support.  However, I think we'll need to get Balbir and
> Kamezawa-san involved to sort out the interaction with memory control
> group.
> 
> I can send you the more recent rebase that I've done.  This is getting
> pretty old now:  2.6.28-rc4-mmotm-081110-081117.  I'll try to rebase to
> the most recent mmotm [that boots on my platforms], at least so that we
> can build and boot with migrate-on-fault disabled, within the next
> couple of weeks.
> 

Sounds good! Send me your last version and I will try to reconstruct your
problems. Afterwards, we could try to solve these problems.

Regards,

Stefan

