Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbXJ2SK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbXJ2SK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbXJ2SKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:10:14 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35712 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbXJ2SKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:10:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Adrian Bunk <bunk@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Kir Kolyshkin <kir@swsoft.com>, containers@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, kir@openvz.org
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com>
	<m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com>
	<20071027002448.GH30533@stusta.de>
	<m18x5puyw7.fsf@ebiederm.dsl.xmission.com> <4724B4F2.7070500@goop.org>
	<20071028170008.GD7227@stusta.de>
	<m13avvqef1.fsf@ebiederm.dsl.xmission.com>
	<4725B256.3020807@fr.ibm.com>
Date: Mon, 29 Oct 2007 12:08:45 -0600
In-Reply-To: <4725B256.3020807@fr.ibm.com> (Cedric Le Goater's message of
	"Mon, 29 Oct 2007 11:13:42 +0100")
Message-ID: <m18x5lpzde.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater <clg@fr.ibm.com> writes:

> Pavel also has a CONFIG_NAMESPACES patch that he should be resending to 
> andrew when 2.6.24-rc1-mm1 is released. pidns will go under this option, 
> like all the other namespaces, and should protect the distros from shipping 
> any immature namespace.

Thanks, As long as we get a config option on there I am happy.

Eric
