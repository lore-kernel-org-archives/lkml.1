Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYGRJ1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYGRJ1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYGRJ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:27:43 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:52895 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbYGRJ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:27:42 -0400
To: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>
Date: Fri, 18 Jul 2008 11:27:18 +0200
In-Reply-To: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl> (Marcin Obara's message of "Thu, 17 Jul 2008 20:27:10 +0200 (CEST)")
Message-ID: <874p6nsft5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2008 09:27:37.0507 (UTC) FILETIME=[84862730:01C8E8B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Obara <marcin_obara@users.sourceforge.net> writes:

> Fixed more issues raised on lkml after previous submission.

How about the save oops data in HECI code? Will that be posted
on top of this?

-Andi
