Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZENU3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZENU3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZENU3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:29:08 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:36703 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756048AbZENU3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:29:07 -0400
Date: Thu, 14 May 2009 16:11:52 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Brice Goglin <Brice.Goglin@inria.fr>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] migration: only migrate_prep() once per move_pages()
In-Reply-To: <4A0A600F.9010801@inria.fr>
Message-ID: <alpine.DEB.1.10.0905141611410.15881@qirst.com>
References: <49E58D7A.4010708@ens-lyon.org> <20090415164955.41746866.kamezawa.hiroyu@jp.fujitsu.com> <4A0A600F.9010801@inria.fr>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I acked it.

