Return-Path: <linux-kernel-owner+w=401wt.eu-S1762525AbYJJQhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762525AbYJJQhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760885AbYJJQhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:37:17 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57135 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760446AbYJJQhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:37:16 -0400
Subject: Re: [RFC][PATCH 1/2] Track in-kernel when we
	expect	checkpoint/restart to work
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Ingo Molnar <mingo@elte.hu>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <1223656489.10017.33.camel@localhost.localdomain>
References: <20081009190405.13A253CB@kernel>
	 <1223626834.8787.8.camel@localhost.localdomain>
	 <48EF144D.1050906@fr.ibm.com> <20081010145934.GF11695@elte.hu>
	 <48EF7211.2000303@cs.columbia.edu>
	 <1223656489.10017.33.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 09:36:43 -0700
Message-Id: <1223656603.11830.50.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 18:34 +0200, Greg Kurz wrote:
> This flag is weak... testing it gives absolutly no hint whether the
> checkpoint may succeed or not. As it is designed now, a user can only be
> aware that checkpoint is *forever* denied. I agree that it's only useful
> as a "flexible CR todo list".

Cool, so everyone agrees the patch is useful!

-- Dave

