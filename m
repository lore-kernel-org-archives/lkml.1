Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYIISGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYIISGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbYIISG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:06:28 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53348 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbYIISG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:06:27 -0400
Subject: Re: [RFC v4][PATCH 0/9] Kernel based checkpoint/restart`
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 11:06:22 -0700
Message-Id: <1220983582.23386.223.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote:
> These patches implement checkpoint-restart [CR v3]. This version is
> aimed at addressing feedback and eliminating bugs, after having added
> save and restore of open files state (regular files and directories)
> which makes it more usable.

Cool, I can actually apply these! :)

-- Dave

