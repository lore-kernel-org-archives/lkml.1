Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbZFIVCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbZFIVCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZFIVC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:02:29 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36565 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZFIVC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:02:28 -0400
Date: Tue, 9 Jun 2009 23:04:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel-doc: cleanup perl script
Message-ID: <20090609210446.GB21727@uranus.ravnborg.org>
References: <4A2E84CE.30703@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2E84CE.30703@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 08:50:38AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Various cleanups of scripts/kernel-doc:
> - don't use **/ as an ending kernel-doc block since it's not preferred;
> - typos/spellos
> - add whitespace around ==, after comma, & around . operator;
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied,
	Sam
