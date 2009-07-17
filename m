Return-Path: <linux-kernel-owner+w=401wt.eu-S964931AbZGQQjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931AbZGQQjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 12:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964913AbZGQQji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 12:39:38 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:40952 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964897AbZGQQji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 12:39:38 -0400
Date: Fri, 17 Jul 2009 12:39:11 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Xiaotian Feng <dfeng@redhat.com>
cc: penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slub: release kobject if sysfs_create_group failed
 in sysfs_slab_add
In-Reply-To: <1247828908-13921-1-git-send-email-dfeng@redhat.com>
Message-ID: <alpine.DEB.1.10.0907171238550.11303@gentwo.org>
References: <1247828908-13921-1-git-send-email-dfeng@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Christoph Lameter <cl@linux-foundation.org>

